#!/usr/bin/env python3
"""
Downloads or copies FSI Demo sample data files.
"""
import os
import shutil

EXPECTED_FILES = [
    "asset_info.csv",
    "pricing_info.csv",
    "historic_pricing_info.csv",
    "account_info.csv",
    "portfolio.csv",
    "portfolio_asset_map.csv",
    "transaction_info.csv",
    "generated_name_info.csv",
]


def download_data():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, "data")
    os.makedirs(output_dir, exist_ok=True)

    # Check if all files already present
    all_exist = all(os.path.exists(os.path.join(output_dir, f)) for f in EXPECTED_FILES)
    if all_exist:
        print(f"[OK] All FSI Demo data files already exist in {output_dir}")
        return

    # Check local data source in snowflake-setup
    local_source = os.path.abspath(os.path.join(script_dir, "..", "..", "snowflake-setup", "fsi_demo", "data"))
    if os.path.isdir(local_source):
        print(f"Found local data source in {local_source}. Copying files...")
        copied = 0
        for f in EXPECTED_FILES:
            src_file = os.path.join(local_source, f)
            dst_file = os.path.join(output_dir, f)
            if os.path.exists(src_file):
                shutil.copy2(src_file, dst_file)
                copied += 1
        if copied == len(EXPECTED_FILES):
            print(f"[OK] Successfully copied all {copied} files from local source.")
            return

    missing = [f for f in EXPECTED_FILES if not os.path.exists(os.path.join(output_dir, f))]
    print(f"[WARN] Missing files in {output_dir}: {missing}")


if __name__ == "__main__":
    download_data()
