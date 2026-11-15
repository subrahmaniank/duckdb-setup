#!/usr/bin/env python3
"""
Downloads or copies AdventureWorks DW CSV data files.
Source: https://github.com/microsoft/sql-server-samples/
"""
import os
import shutil
import urllib.request

FILES = [
    "DatabaseLog.csv",
    "DimAccount.csv",
    "DimCurrency.csv",
    "DimCustomer.csv",
    "DimDate.csv",
    "DimDepartmentGroup.csv",
    "DimEmployee.csv",
    "DimGeography.csv",
    "DimOrganization.csv",
    "DimProduct.csv",
    "DimProductCategory.csv",
    "DimProductSubcategory.csv",
    "DimPromotion.csv",
    "DimReseller.csv",
    "DimSalesReason.csv",
    "DimSalesTerritory.csv",
    "DimScenario.csv",
    "FactAdditionalInternationalProductDescription.csv",
    "FactCallCenter.csv",
    "FactCurrencyRate.csv",
    "FactFinance.csv",
    "FactInternetSales.csv",
    "FactInternetSalesReason.csv",
    "FactProductInventory.csv",
    "FactResellerSales.csv",
    "FactSalesQuota.csv",
    "FactSurveyResponse.csv",
    "NewFactCurrencyRate.csv",
    "ProspectiveBuyer.csv",
]

BASE_URL = "https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/databases/adventure-works/data-warehouse-install-script/"


def download_data():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, "data")
    os.makedirs(output_dir, exist_ok=True)

    # Check if all files already exist
    all_exist = all(os.path.exists(os.path.join(output_dir, f)) for f in FILES)
    if all_exist:
        print(f"[OK] All AdventureWorks DW data files already exist in {output_dir}")
        return

    # Check local source in snowflake-setup
    local_source = os.path.abspath(os.path.join(script_dir, "..", "..", "snowflake-setup", "adventureworks_dw", "data"))
    if os.path.isdir(local_source):
        print(f"Found local data source in {local_source}. Copying files...")
        copied = 0
        for f in FILES:
            src_file = os.path.join(local_source, f)
            dst_file = os.path.join(output_dir, f)
            if os.path.exists(src_file):
                shutil.copy2(src_file, dst_file)
                copied += 1
        if copied == len(FILES):
            print(f"[OK] Successfully copied all {copied} files from local source.")
            return

    # Download from GitHub
    print(f"Downloading AdventureWorks DW data files from GitHub...")
    for f in FILES:
        url = BASE_URL + f
        dst_file = os.path.join(output_dir, f)
        print(f"  Downloading {f}...")
        try:
            urllib.request.urlretrieve(url, dst_file)
        except Exception as e:
            print(f"  [ERROR] Failed to download {f}: {e}")

    print(f"[OK] AdventureWorks DW data ready in {output_dir}")


if __name__ == "__main__":
    download_data()
