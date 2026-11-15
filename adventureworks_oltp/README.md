# AdventureWorks OLTP Database for DuckDB

This package builds and loads the complete AdventureWorks OLTP database (including all 68 tables across 5 schemas) into a local [DuckDB](https://duckdb.org/) database (`adventureworks_oltp.duckdb` and `adventureworks.duckdb`).

## Quick Start

### Build the Database

**Using PowerShell:**
```powershell
.\deploy.ps1
```

**Using Bash:**
```bash
./deploy.sh
```

**Using Python:**
```bash
python build.py
# or with uv:
uv run --with duckdb python build.py
```

This will automatically:
1. Verify or copy required CSV data files into `data/`
2. Create `adventureworks_oltp.duckdb` (and companion alias `adventureworks.duckdb`)
3. Create all schemas: `humanresources`, `person`, `production`, `purchasing`, `sales`
4. Load all 68 tables with high-speed parallel CSV ingestion
5. Validate row counts against expected metrics

## Schemas & Tables Summary

### 1. Person Schema (13 tables)
- `person.Address` (19,614 rows)
- `person.AddressType` (6 rows)
- `person.BusinessEntity` (20,777 rows)
- `person.BusinessEntityAddress` (19,614 rows)
- `person.BusinessEntityContact` (909 rows)
- `person.ContactType` (20 rows)
- `person.CountryRegion` (238 rows)
- `person.EmailAddress` (19,972 rows)
- `person.Password` (19,972 rows)
- `person.Person` (19,972 rows)
- `person.PersonPhone` (19,972 rows)
- `person.PhoneNumberType` (3 rows)
- `person.StateProvince` (181 rows)

### 2. HumanResources Schema (6 tables)
- `humanresources.Department` (16 rows)
- `humanresources.Employee` (290 rows)
- `humanresources.EmployeeDepartmentHistory` (296 rows)
- `humanresources.EmployeePayHistory` (316 rows)
- `humanresources.JobCandidate` (13 rows)
- `humanresources.Shift` (3 rows)

### 3. Production Schema (25 tables)
- `production.BillOfMaterials` (2,679 rows)
- `production.Culture` (8 rows)
- `production.Document` (13 rows)
- `production.Illustration` (5 rows)
- `production.Location` (14 rows)
- `production.Product` (504 rows)
- `production.ProductCategory` (4 rows)
- `production.ProductCostHistory` (395 rows)
- `production.ProductDescription` (762 rows)
- `production.ProductDocument` (32 rows)
- `production.ProductInventory` (1,069 rows)
- `production.ProductListPriceHistory` (395 rows)
- `production.ProductModel` (128 rows)
- `production.ProductModelIllustration` (7 rows)
- `production.ProductModelProductDescriptionCulture` (762 rows)
- `production.ProductPhoto` (101 rows)
- `production.ProductProductPhoto` (504 rows)
- `production.ProductReview` (4 rows)
- `production.ProductSubcategory` (37 rows)
- `production.ScrapReason` (16 rows)
- `production.TransactionHistory` (113,443 rows)
- `production.TransactionHistoryArchive` (89,253 rows)
- `production.UnitMeasure` (38 rows)
- `production.WorkOrder` (72,591 rows)
- `production.WorkOrderRouting` (67,131 rows)

### 4. Purchasing Schema (5 tables)
- `purchasing.ProductVendor` (460 rows)
- `purchasing.PurchaseOrderDetail` (8,845 rows)
- `purchasing.PurchaseOrderHeader` (4,012 rows)
- `purchasing.ShipMethod` (5 rows)
- `purchasing.Vendor` (104 rows)

### 5. Sales Schema (19 tables)
- `sales.CountryRegionCurrency` (109 rows)
- `sales.CreditCard` (19,118 rows)
- `sales.Currency` (105 rows)
- `sales.CurrencyRate` (13,532 rows)
- `sales.Customer` (19,820 rows)
- `sales.PersonCreditCard` (19,118 rows)
- `sales.SalesOrderDetail` (121,317 rows)
- `sales.SalesOrderHeader` (31,465 rows)
- `sales.SalesOrderHeaderSalesReason` (27,647 rows)
- `sales.SalesPerson` (17 rows)
- `sales.SalesPersonQuotaHistory` (163 rows)
- `sales.SalesReason` (10 rows)
- `sales.SalesTaxRate` (29 rows)
- `sales.SalesTerritory` (10 rows)
- `sales.SalesTerritoryHistory` (17 rows)
- `sales.ShoppingCartItem` (3 rows)
- `sales.SpecialOffer` (16 rows)
- `sales.SpecialOfferProduct` (538 rows)
- `sales.Store` (701 rows)

## Querying DuckDB

```python
import duckdb

conn = duckdb.connect("adventureworks_oltp.duckdb")

# Top 10 products by total sales
df = conn.execute("""
    SELECT 
        p.Name AS ProductName,
        SUM(d.OrderQty) AS TotalQuantitySold,
        SUM(d.LineTotal) AS TotalRevenue
    FROM sales.SalesOrderDetail d
    JOIN production.Product p ON d.ProductID = p.ProductID
    GROUP BY p.Name
    ORDER BY TotalRevenue DESC
    LIMIT 10;
""").df()

print(df)
```
