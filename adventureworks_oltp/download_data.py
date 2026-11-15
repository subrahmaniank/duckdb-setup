#!/usr/bin/env python3
"""
Downloads or copies AdventureWorks OLTP CSV data files.
Source: https://github.com/microsoft/sql-server-samples/
"""
import os
import shutil
import urllib.request

FILES = [
    "Address.csv",
    "AddressType.csv",
    "BillOfMaterials.csv",
    "BusinessEntity.csv",
    "BusinessEntityAddress.csv",
    "BusinessEntityContact.csv",
    "ContactType.csv",
    "CountryRegion.csv",
    "CountryRegionCurrency.csv",
    "CreditCard.csv",
    "Culture.csv",
    "Currency.csv",
    "CurrencyRate.csv",
    "Customer.csv",
    "Department.csv",
    "Document.csv",
    "EmailAddress.csv",
    "Employee.csv",
    "EmployeeDepartmentHistory.csv",
    "EmployeePayHistory.csv",
    "Illustration.csv",
    "JobCandidate.csv",
    "Location.csv",
    "Password.csv",
    "Person.csv",
    "PersonCreditCard.csv",
    "PersonPhone.csv",
    "PhoneNumberType.csv",
    "Product.csv",
    "ProductCategory.csv",
    "ProductCostHistory.csv",
    "ProductDescription.csv",
    "ProductDocument.csv",
    "ProductInventory.csv",
    "ProductListPriceHistory.csv",
    "ProductModel.csv",
    "ProductModelIllustration.csv",
    "ProductModelProductDescriptionCulture.csv",
    "ProductPhoto.csv",
    "ProductProductPhoto.csv",
    "ProductReview.csv",
    "ProductSubcategory.csv",
    "ProductVendor.csv",
    "PurchaseOrderDetail.csv",
    "PurchaseOrderHeader.csv",
    "SalesOrderDetail.csv",
    "SalesOrderHeader.csv",
    "SalesOrderHeaderSalesReason.csv",
    "SalesPerson.csv",
    "SalesPersonQuotaHistory.csv",
    "SalesReason.csv",
    "SalesTaxRate.csv",
    "SalesTerritory.csv",
    "SalesTerritoryHistory.csv",
    "ScrapReason.csv",
    "Shift.csv",
    "ShipMethod.csv",
    "ShoppingCartItem.csv",
    "SpecialOffer.csv",
    "SpecialOfferProduct.csv",
    "StateProvince.csv",
    "Store.csv",
    "TransactionHistory.csv",
    "TransactionHistoryArchive.csv",
    "UnitMeasure.csv",
    "Vendor.csv",
    "WorkOrder.csv",
    "WorkOrderRouting.csv",
]

BASE_URL = "https://raw.githubusercontent.com/microsoft/sql-server-samples/master/samples/databases/adventure-works/oltp-install-script/"


def download_data():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_dir = os.path.join(script_dir, "data")
    os.makedirs(output_dir, exist_ok=True)

    # Check if all files already exist
    all_exist = all(os.path.exists(os.path.join(output_dir, f)) for f in FILES)
    if all_exist:
        print(f"[OK] All AdventureWorks OLTP data files already exist in {output_dir}")
        return

    # Check local source in snowflake-setup
    local_source = os.path.abspath(os.path.join(script_dir, "..", "..", "snowflake-setup", "adventureworks_oltp", "data"))
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
    print(f"Downloading AdventureWorks OLTP data files from GitHub...")
    for f in FILES:
        url = BASE_URL + f
        dst_file = os.path.join(output_dir, f)
        print(f"  Downloading {f}...")
        try:
            urllib.request.urlretrieve(url, dst_file)
        except Exception as e:
            print(f"  [ERROR] Failed to download {f}: {e}")

    print(f"[OK] AdventureWorks OLTP data ready in {output_dir}")


if __name__ == "__main__":
    download_data()
