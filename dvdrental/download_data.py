#!/usr/bin/env python3
"""
Downloads or copies DVD Rental sample data files.
Source: https://github.com/ajgreyling/dvdrental
"""
import os
import shutil
import urllib.request

FILE_MAPPINGS = {
    "2163.dat": "actor.csv",
    "2165.dat": "category.csv",
    "2167.dat": "film.csv",
    "2168.dat": "film_actor.csv",
    "2169.dat": "film_category.csv",
    "2171.dat": "address.csv",
    "2173.dat": "city.csv",
    "2175.dat": "country.csv",
    "2177.dat": "customer.csv",
    "2179.dat": "inventory.csv",
    "2181.dat": "language.csv",
    "2183.dat": "payment.csv",
    "2185.dat": "rental.csv",
    "2187.dat": "staff.csv",
    "2189.dat": "store.csv",
}

BASE_URL = "https://raw.githubusercontent.com/ajgreyling/dvdrental/master/"


def download_data():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, "data")
    os.makedirs(output_dir, exist_ok=True)

    # Check if all files already present
    all_exist = all(os.path.exists(os.path.join(output_dir, tgt)) for tgt in FILE_MAPPINGS.values())
    if all_exist:
        print(f"[OK] All DVD Rental data files already exist in {output_dir}")
        return

    # Check if existing local data exists in snowflake-setup
    local_source = os.path.abspath(os.path.join(script_dir, "..", "..", "snowflake-setup", "dvdrental", "data"))
    if os.path.isdir(local_source):
        print(f"Found local data source in {local_source}. Copying files...")
        copied = 0
        for tgt in FILE_MAPPINGS.values():
            src_file = os.path.join(local_source, tgt)
            dst_file = os.path.join(output_dir, tgt)
            if os.path.exists(src_file):
                shutil.copy2(src_file, dst_file)
                copied += 1
        if copied == len(FILE_MAPPINGS):
            print(f"[OK] Successfully copied all {copied} files from local source.")
            return

    # Download from GitHub
    print(f"Downloading DVD Rental files from {BASE_URL}...")
    for src_dat, tgt_csv in FILE_MAPPINGS.items():
        url = BASE_URL + src_dat
        dst_path = os.path.join(output_dir, tgt_csv)
        print(f"  Downloading {src_dat} -> {tgt_csv}...")
        urllib.request.urlretrieve(url, dst_path)

        # Clean up postgres COPY terminators '\.'
        with open(dst_path, "r", encoding="utf-8", errors="ignore") as f:
            lines = [line for line in f if line.strip() != r"\." and line.strip() != ""]
        with open(dst_path, "w", encoding="utf-8", newline="\n") as f:
            f.writelines(lines)

    print(f"[OK] DVD Rental data ready in {output_dir}")


if __name__ == "__main__":
    download_data()
