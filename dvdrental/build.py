#!/usr/bin/env python3
"""
Builds the DuckDB dvdrental database from CSV data.
Usage:
    python build.py [--output dvdrental.duckdb]
"""
import argparse
import os
import sys
import time

try:
    import duckdb
except ImportError:
    print("Error: duckdb package is not installed. Install with: pip install duckdb")
    sys.exit(1)

import importlib.util

dl_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "download_data.py")
spec = importlib.util.spec_from_file_location("dvdrental_download_data", dl_path)
dl_mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dl_mod)
download_data = dl_mod.download_data


def build_database(output_path=None):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    if not output_path:
        output_path = os.path.join(script_dir, "dvdrental.duckdb")
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
    print("\n[1/4] Setting up schemas...")
    with open(os.path.join(script_dir, "01_setup_database.sql"), "r", encoding="utf-8") as f:
        conn.execute(f.read())

    # 3. Create Tables
    print("[2/4] Creating tables...")
    with open(os.path.join(script_dir, "02_create_tables.sql"), "r", encoding="utf-8") as f:
        conn.execute(f.read())

    # 4. Load Data
    print("[3/4] Loading CSV data...")
    tables = [
        "actor", "category", "language", "country", "city", "address",
        "film", "film_actor", "film_category", "staff", "store", "customer",
        "inventory", "rental", "payment"
    ]
    for tbl in tables:
        csv_file = os.path.join(data_dir, f"{tbl}.csv").replace("\\", "/")
        conn.execute(f"COPY {tbl} FROM '{csv_file}' (DELIMITER '\t', HEADER false, NULL '\\N');")

    # 5. Validate Data
    print("[4/4] Validating data counts...\n")
    with open(os.path.join(script_dir, "04_validate_data.sql"), "r", encoding="utf-8") as f:
        val_sql = f.read()

    res = conn.execute(val_sql).fetchall()
    print(f"  {'Table Name':<20} {'Expected':<12} {'Actual':<12} {'Status':<8}")
    print("  " + "-" * 54)

    all_pass = True
    for row in res:
        tbl_name, exp_cnt, act_cnt, status = row
        status_str = f"[{status}]"
        print(f"  {tbl_name:<20} {exp_cnt:<12} {act_cnt:<12} {status_str:<8}")
        if status != "PASS":
            all_pass = False

    conn.close()
    elapsed = time.time() - start_time
    file_size_mb = os.path.getsize(output_path) / (1024 * 1024)

    print("  " + "-" * 54)
    if all_pass:
        print(f"\n[OK] DVD Rental database built successfully in {elapsed:.2f}s! ({file_size_mb:.2f} MB)")
        return 0
    else:
        print(f"\n[WARN] Validation had issues. Check table counts above.")
        return 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build DuckDB DVD Rental database.")
    parser.add_argument("--output", "-o", help="Target .duckdb file path", default=None)
    args = parser.parse_args()
    sys.exit(build_database(args.output))
