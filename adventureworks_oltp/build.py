#!/usr/bin/env python3
"""
Builds the DuckDB AdventureWorks OLTP database from CSV data.
Usage:
    python build.py [--output adventureworks_oltp.duckdb]
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
spec = importlib.util.spec_from_file_location("aw_oltp_download_data", dl_path)
dl_mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dl_mod)
download_data = dl_mod.download_data


TABLE_MAP = {
    # Person
    "person.Address": "Address.csv",
    "person.AddressType": "AddressType.csv",
    "person.BusinessEntity": "BusinessEntity.csv",
    "person.BusinessEntityAddress": "BusinessEntityAddress.csv",
    "person.BusinessEntityContact": "BusinessEntityContact.csv",
    "person.ContactType": "ContactType.csv",
    "person.CountryRegion": "CountryRegion.csv",
    "person.EmailAddress": "EmailAddress.csv",
    "person.Password": "Password.csv",
    "person.Person": "Person.csv",
    "person.PersonPhone": "PersonPhone.csv",
    "person.PhoneNumberType": "PhoneNumberType.csv",
    "person.StateProvince": "StateProvince.csv",
    # HumanResources
    "humanresources.Department": "Department.csv",
    "humanresources.Employee": "Employee.csv",
    "humanresources.EmployeeDepartmentHistory": "EmployeeDepartmentHistory.csv",
    "humanresources.EmployeePayHistory": "EmployeePayHistory.csv",
    "humanresources.JobCandidate": "JobCandidate.csv",
    "humanresources.Shift": "Shift.csv",
    # Production
    "production.BillOfMaterials": "BillOfMaterials.csv",
    "production.Culture": "Culture.csv",
    "production.Document": "Document.csv",
    "production.Illustration": "Illustration.csv",
    "production.Location": "Location.csv",
    "production.Product": "Product.csv",
    "production.ProductCategory": "ProductCategory.csv",
    "production.ProductCostHistory": "ProductCostHistory.csv",
    "production.ProductDescription": "ProductDescription.csv",
    "production.ProductDocument": "ProductDocument.csv",
    "production.ProductInventory": "ProductInventory.csv",
    "production.ProductListPriceHistory": "ProductListPriceHistory.csv",
    "production.ProductModel": "ProductModel.csv",
    "production.ProductModelIllustration": "ProductModelIllustration.csv",
    "production.ProductModelProductDescriptionCulture": "ProductModelProductDescriptionCulture.csv",
    "production.ProductPhoto": "ProductPhoto.csv",
    "production.ProductProductPhoto": "ProductProductPhoto.csv",
    "production.ProductReview": "ProductReview.csv",
    "production.ProductSubcategory": "ProductSubcategory.csv",
    "production.ScrapReason": "ScrapReason.csv",
    "production.TransactionHistory": "TransactionHistory.csv",
    "production.TransactionHistoryArchive": "TransactionHistoryArchive.csv",
    "production.UnitMeasure": "UnitMeasure.csv",
    "production.WorkOrder": "WorkOrder.csv",
    "production.WorkOrderRouting": "WorkOrderRouting.csv",
    # Purchasing
    "purchasing.ProductVendor": "ProductVendor.csv",
    "purchasing.PurchaseOrderDetail": "PurchaseOrderDetail.csv",
    "purchasing.PurchaseOrderHeader": "PurchaseOrderHeader.csv",
    "purchasing.ShipMethod": "ShipMethod.csv",
    "purchasing.Vendor": "Vendor.csv",
    # Sales
    "sales.CountryRegionCurrency": "CountryRegionCurrency.csv",
    "sales.CreditCard": "CreditCard.csv",
    "sales.Currency": "Currency.csv",
    "sales.CurrencyRate": "CurrencyRate.csv",
    "sales.Customer": "Customer.csv",
    "sales.PersonCreditCard": "PersonCreditCard.csv",
    "sales.SalesOrderDetail": "SalesOrderDetail.csv",
    "sales.SalesOrderHeader": "SalesOrderHeader.csv",
    "sales.SalesOrderHeaderSalesReason": "SalesOrderHeaderSalesReason.csv",
    "sales.SalesPerson": "SalesPerson.csv",
    "sales.SalesPersonQuotaHistory": "SalesPersonQuotaHistory.csv",
    "sales.SalesReason": "SalesReason.csv",
    "sales.SalesTaxRate": "SalesTaxRate.csv",
    "sales.SalesTerritory": "SalesTerritory.csv",
    "sales.SalesTerritoryHistory": "SalesTerritoryHistory.csv",
    "sales.ShoppingCartItem": "ShoppingCartItem.csv",
    "sales.SpecialOffer": "SpecialOffer.csv",
    "sales.SpecialOfferProduct": "SpecialOfferProduct.csv",
    "sales.Store": "Store.csv",
}


def build_database(output_path=None):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    if not output_path:
        output_path = os.path.join(script_dir, "adventureworks_oltp.duckdb")
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
    print(f"[3/4] Loading {len(TABLE_MAP)} tables across 5 schemas...")
    for tbl, fn in TABLE_MAP.items():
        csv_file = os.path.join(data_dir, fn).replace("\\", "/")
        conn.execute(f"COPY {tbl} FROM '{csv_file}' (DELIMITER '\t', HEADER false, NULL '');")

    # 5. Validate Data
    print("[4/4] Validating data counts...\n")
    with open(os.path.join(script_dir, "04_validate_data.sql"), "r", encoding="utf-8") as f:
        val_sql = f.read()

    res = conn.execute(val_sql).fetchall()
    print(f"  {'Schema':<16} {'Table Name':<38} {'Expected':<10} {'Actual':<10} {'Status':<8}")
    print("  " + "-" * 88)

    all_pass = True
    for row in res:
        sch_name, tbl_name, exp_cnt, act_cnt, status = row
        status_str = f"[{status}]"
        print(f"  {sch_name:<16} {tbl_name:<38} {exp_cnt:<10} {act_cnt:<10} {status_str:<8}")
        if status != "PASS":
            all_pass = False

    conn.close()

    # Create companion alias adventureworks.duckdb
    if os.path.basename(output_path) == "adventureworks_oltp.duckdb":
        aw_alias = os.path.join(os.path.dirname(output_path), "adventureworks.duckdb")
        try:
            shutil.copy2(output_path, aw_alias)
            print(f"\n  Created companion alias: {aw_alias}")
        except Exception:
            pass

    elapsed = time.time() - start_time
    file_size_mb = os.path.getsize(output_path) / (1024 * 1024)

    print("  " + "-" * 88)
    if all_pass:
        print(f"\n[OK] AdventureWorks OLTP database built successfully in {elapsed:.2f}s! ({file_size_mb:.2f} MB)")
        return 0
    else:
        print(f"\n[WARN] Validation had issues. Check table counts above.")
        return 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Build DuckDB AdventureWorks OLTP database.")
    parser.add_argument("--output", "-o", help="Target .duckdb file path", default=None)
    args = parser.parse_args()
    sys.exit(build_database(args.output))
