#!/usr/bin/env python3
"""
Builds the DuckDB FSI Demo database from CSV data.
Usage:
    python build.py [--output fsi_demo.duckdb]
"""
import argparse
import os
import shutil
import sys
import time

try:
    import duckdb
except ImportError:
    print("Error: duckdb package is not installed. Install with: pip install duckdb")
    sys.exit(1)

import importlib.util

dl_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "download_data.py")
spec = importlib.util.spec_from_file_location("fsi_demo_download_data", dl_path)
dl_mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dl_mod)
download_data = dl_mod.download_data


def build_database(output_path=None):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    if not output_path:
        output_path = os.path.join(script_dir, "fsi_demo.duckdb")
    else:
        output_path = os.path.abspath(output_path)

    # 1. Download or verify data files
    data_dir = os.path.join(script_dir, "data")
    download_data()

    print(f"\n==========================================")
    print(f"Building DuckDB database: {output_path}")
    print(f"==========================================")
    start_time = time.time()

    # Clean existing database file
    if os.path.exists(output_path):
        try:
            os.remove(output_path)
        except OSError:
            pass

    conn = duckdb.connect(output_path)

    # 2. Setup Database & Schemas
    print("\n[1/4] Setting up schemas, sequences, and macros...")
    with open(os.path.join(script_dir, "01_setup_database.sql"), "r", encoding="utf-8") as f:
        conn.execute(f.read())

    # 3. Create Tables
    print("[2/4] Creating tables...")
    with open(os.path.join(script_dir, "02_create_tables.sql"), "r", encoding="utf-8") as f:
        conn.execute(f.read())

    # 4. Load Data
    print("[3/4] Loading and calculating data (640,000+ rows)...")
    src = data_dir.replace("\\", "/")

    # Reference / Lookup
    conn.execute(f"""
    INSERT INTO Asset_Info (Ticker, Cusip, Scrip_Name)
    SELECT Ticker, Cusip, Scrip_Name FROM read_csv('{src}/asset_info.csv', header=true);
    """)

    conn.execute(f"""
    INSERT INTO generated_name_info (first_name, middle_name, last_name, full_name)
    SELECT first_name, middle_name, last_name, full_name FROM read_csv('{src}/generated_name_info.csv', header=true);
    """)

    # Accounts
    conn.execute(f"""
    INSERT INTO account_info (account_name, account_start_date, account_end_date, account_status, primary_owner_tax_id)
    SELECT account_name, account_start_date, account_end_date, account_status, primary_owner_tax_id FROM read_csv('{src}/account_info.csv', header=true);
    """)

    # Pricing
    conn.execute(f"""
    INSERT INTO Pricing_Info (Asset_Info_ID, Pricing_Date, Last_Traded_Price, Volume, Open_Price, High_Price, Low_Price)
    SELECT Asset_Info_ID, Pricing_Date, Last_Traded_Price, Volume, Open_price, High_price, Low_price FROM read_csv('{src}/pricing_info.csv', header=true);
    """)

    conn.execute(f"""
    INSERT INTO Historical_Pricing_Info (Pricing_Date, Last_Traded_Price, Volume, Open, High, Low, Ticker, Cusip, Scrip_Name)
    SELECT Pricing_Date, Last_Traded_Price, Volume, Open, High, Low, Ticker, Cusip, Scrip_Name FROM read_csv('{src}/historic_pricing_info.csv', header=true);
    """)

    # Portfolios
    conn.execute(f"""
    INSERT INTO portfolio (portfolio_name, account_id)
    SELECT portfolio_name, account_id FROM read_csv('{src}/portfolio.csv', header=true);
    """)

    conn.execute(f"""
    INSERT INTO portfolio_asset_map (portfolio_id, asset_info_id)
    SELECT portfolio_id, asset_info_id FROM read_csv('{src}/portfolio_asset_map.csv', header=true);
    """)

    # Transactions
    conn.execute(f"""
    INSERT INTO transaction_info (portfolio_asset_map_id, transaction_date, quantity, transaction_price, transaction_fee, transaction_tax, settlement_date, transaction_description, performed_by_user, transaction_status)
    SELECT portfolio_asset_map_id, transaction_date, quantity, transaction_price, transaction_fee, transaction_tax, settlement_date, transaction_description, performed_by_user, transaction_status FROM read_csv('{src}/transaction_info.csv', header=true);
    """)

    # Calculate quantities, prices, fees, and taxes
    conn.execute("""
    UPDATE transaction_info
    SET
        quantity = q.qty,
        transaction_price = q.qty * transaction_info.transaction_price,
        transaction_fee = (q.qty * transaction_info.transaction_price) * 0.3,
        transaction_tax = (q.qty * transaction_info.transaction_price) * 0.1
    FROM (
        SELECT transaction_info_id, CAST(FLOOR(random() * 9000 + 1000) AS INTEGER) AS qty
        FROM transaction_info
    ) q
    WHERE transaction_info.transaction_info_id = q.transaction_info_id;
    """)

    # 5. Validate Data
    print("[4/4] Validating data counts...\n")
    with open(os.path.join(script_dir, "04_validate_data.sql"), "r", encoding="utf-8") as f:
        val_sql = f.read()

    res = conn.execute(val_sql).fetchall()
    print(f"  {'Table Name':<28} {'Expected':<12} {'Actual':<12} {'Status':<8}")
    print("  " + "-" * 62)

    all_pass = True
    for row in res:
        tbl_name, exp_cnt, act_cnt, status = row
        status_str = f"[{status}]"
        print(f"  {tbl_name:<28} {exp_cnt:<12} {act_cnt:<12} {status_str:<8}")
        if status != "PASS":
            all_pass = False

    conn.close()

    # Also provide sei_demo.duckdb alias if default output
    if os.path.basename(output_path) == "fsi_demo.duckdb":
        sei_alias = os.path.join(os.path.dirname(output_path), "sei_demo.duckdb")
        try:
            shutil.copy2(output_path, sei_alias)
            print(f"  Created companion alias: {sei_alias}")
        except Exception:
            pass

    elapsed = time.time() - start_time
    file_size_mb = os.path.getsize(output_path) / (1024 * 1024)

    print("  " + "-" * 62)
    if all_pass:
        print(f"\n[OK] FSI Demo database built successfully in {elapsed:.2f}s! ({file_size_mb:.2f} MB)")
        return 0
    else:
        print(f"\n[WARN] Validation had issues. Check table counts above.")
        return 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build DuckDB FSI Demo database.")
    parser.add_argument("--output", "-o", help="Target .duckdb file path", default=None)
    args = parser.parse_args()
    sys.exit(build_database(args.output))
