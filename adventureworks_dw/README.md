# AdventureWorks Data Warehouse (DW) for DuckDB

This package builds and loads the classic AdventureWorks Data Warehouse dimensional star schema into a local [DuckDB](https://duckdb.org/) database (`adventureworks_dw.duckdb`).

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
2. Create `adventureworks_dw.duckdb`
3. Create all dimension and fact tables
4. Load over 1,000,000 records across 29 tables
5. Validate row counts against expected metrics

## Tables Included

### Dimensions
- `DimAccount` (99 rows)
- `DimCurrency` (105 rows)
- `DimCustomer` (18,484 rows)
- `DimDate` (3,652 rows)
- `DimDepartmentGroup` (7 rows)
- `DimEmployee` (296 rows)
- `DimGeography` (655 rows)
- `DimOrganization` (14 rows)
- `DimProduct` (606 rows)
- `DimProductCategory` (4 rows)
- `DimProductSubcategory` (37 rows)
- `DimPromotion` (16 rows)
- `DimReseller` (701 rows)
- `DimSalesReason` (10 rows)
- `DimSalesTerritory` (11 rows)
- `DimScenario` (3 rows)

### Facts & Lookups
- `FactAdditionalInternationalProductDescription` (1,911 rows)
- `FactCallCenter` (120 rows)
- `FactCurrencyRate` (14,264 rows)
- `FactFinance` (39,409 rows)
- `FactInternetSales` (60,398 rows)
- `FactInternetSalesReason` (64,515 rows)
- `FactProductInventory` (776,286 rows)
- `FactResellerSales` (60,855 rows)
- `FactSalesQuota` (163 rows)
- `FactSurveyResponse` (2,727 rows)
- `NewFactCurrencyRate` (50 rows)
- `ProspectiveBuyer` (2,059 rows)
- `DatabaseLog` (112 rows)

## Querying DuckDB

```python
import duckdb

conn = duckdb.connect("adventureworks_dw.duckdb")

# Top product categories by internet sales
df = conn.execute("""
    SELECT 
        pc.EnglishProductCategoryName AS Category,
        SUM(fis.SalesAmount) AS TotalSales,
        SUM(fis.OrderQuantity) AS TotalQuantity
    FROM FactInternetSales fis
    JOIN DimProduct p ON fis.ProductKey = p.ProductKey
    JOIN DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
    JOIN DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
    GROUP BY pc.EnglishProductCategoryName
    ORDER BY TotalSales DESC;
""").df()

print(df)
```
