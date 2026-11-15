-- 04_validate_data.sql
-- Purpose: Validate row counts for AdventureWorks OLTP tables in DuckDB

CREATE OR REPLACE TEMP TABLE ExpectedCounts (
    SchemaName VARCHAR,
    TableName VARCHAR,
    ExpectedCount BIGINT
);

INSERT INTO ExpectedCounts VALUES
-- Person schema
('person', 'Address', 19614),
('person', 'AddressType', 6),
('person', 'BusinessEntity', 20777),
('person', 'BusinessEntityAddress', 19614),
('person', 'BusinessEntityContact', 909),
('person', 'ContactType', 20),
('person', 'CountryRegion', 238),
('person', 'EmailAddress', 19972),
('person', 'Password', 19972),
('person', 'Person', 19972),
('person', 'PersonPhone', 19972),
('person', 'PhoneNumberType', 3),
('person', 'StateProvince', 181),
-- HumanResources schema
('humanresources', 'Department', 16),
('humanresources', 'Employee', 290),
('humanresources', 'EmployeeDepartmentHistory', 296),
('humanresources', 'EmployeePayHistory', 316),
('humanresources', 'JobCandidate', 13),
('humanresources', 'Shift', 3),
-- Production schema
('production', 'BillOfMaterials', 2679),
('production', 'Culture', 8),
('production', 'Document', 12),
('production', 'Illustration', 5),
('production', 'Location', 14),
('production', 'Product', 504),
('production', 'ProductCategory', 4),
('production', 'ProductCostHistory', 395),
('production', 'ProductDescription', 762),
('production', 'ProductDocument', 32),
('production', 'ProductInventory', 1069),
('production', 'ProductListPriceHistory', 395),
('production', 'ProductModel', 128),
('production', 'ProductModelIllustration', 7),
('production', 'ProductModelProductDescriptionCulture', 762),
('production', 'ProductPhoto', 101),
('production', 'ProductProductPhoto', 504),
('production', 'ProductReview', 4),
('production', 'ProductSubcategory', 37),
('production', 'ScrapReason', 16),
('production', 'TransactionHistory', 113443),
('production', 'TransactionHistoryArchive', 89253),
('production', 'UnitMeasure', 38),
('production', 'WorkOrder', 72591),
('production', 'WorkOrderRouting', 67131),
-- Purchasing schema
('purchasing', 'ProductVendor', 460),
('purchasing', 'PurchaseOrderDetail', 8845),
('purchasing', 'PurchaseOrderHeader', 4012),
('purchasing', 'ShipMethod', 5),
('purchasing', 'Vendor', 104),
-- Sales schema
('sales', 'CountryRegionCurrency', 109),
('sales', 'CreditCard', 19118),
('sales', 'Currency', 105),
('sales', 'CurrencyRate', 13532),
('sales', 'Customer', 19820),
('sales', 'PersonCreditCard', 19118),
('sales', 'SalesOrderDetail', 121317),
('sales', 'SalesOrderHeader', 31465),
('sales', 'SalesOrderHeaderSalesReason', 27647),
('sales', 'SalesPerson', 17),
('sales', 'SalesPersonQuotaHistory', 163),
('sales', 'SalesReason', 10),
('sales', 'SalesTaxRate', 29),
('sales', 'SalesTerritory', 10),
('sales', 'SalesTerritoryHistory', 17),
('sales', 'ShoppingCartItem', 3),
('sales', 'SpecialOffer', 16),
('sales', 'SpecialOfferProduct', 538),
('sales', 'Store', 701);

WITH ActualCounts AS (
    SELECT 'person' AS SchemaName, 'Address' AS TableName, COUNT(*) AS ActualCount FROM person.Address UNION ALL
    SELECT 'person', 'AddressType', COUNT(*) FROM person.AddressType UNION ALL
    SELECT 'person', 'BusinessEntity', COUNT(*) FROM person.BusinessEntity UNION ALL
    SELECT 'person', 'BusinessEntityAddress', COUNT(*) FROM person.BusinessEntityAddress UNION ALL
    SELECT 'person', 'BusinessEntityContact', COUNT(*) FROM person.BusinessEntityContact UNION ALL
    SELECT 'person', 'ContactType', COUNT(*) FROM person.ContactType UNION ALL
    SELECT 'person', 'CountryRegion', COUNT(*) FROM person.CountryRegion UNION ALL
    SELECT 'person', 'EmailAddress', COUNT(*) FROM person.EmailAddress UNION ALL
    SELECT 'person', 'Password', COUNT(*) FROM person.Password UNION ALL
    SELECT 'person', 'Person', COUNT(*) FROM person.Person UNION ALL
    SELECT 'person', 'PersonPhone', COUNT(*) FROM person.PersonPhone UNION ALL
    SELECT 'person', 'PhoneNumberType', COUNT(*) FROM person.PhoneNumberType UNION ALL
    SELECT 'person', 'StateProvince', COUNT(*) FROM person.StateProvince UNION ALL
    SELECT 'humanresources', 'Department', COUNT(*) FROM humanresources.Department UNION ALL
    SELECT 'humanresources', 'Employee', COUNT(*) FROM humanresources.Employee UNION ALL
    SELECT 'humanresources', 'EmployeeDepartmentHistory', COUNT(*) FROM humanresources.EmployeeDepartmentHistory UNION ALL
    SELECT 'humanresources', 'EmployeePayHistory', COUNT(*) FROM humanresources.EmployeePayHistory UNION ALL
    SELECT 'humanresources', 'JobCandidate', COUNT(*) FROM humanresources.JobCandidate UNION ALL
    SELECT 'humanresources', 'Shift', COUNT(*) FROM humanresources.Shift UNION ALL
    SELECT 'production', 'BillOfMaterials', COUNT(*) FROM production.BillOfMaterials UNION ALL
    SELECT 'production', 'Culture', COUNT(*) FROM production.Culture UNION ALL
    SELECT 'production', 'Document', COUNT(*) FROM production.Document UNION ALL
    SELECT 'production', 'Illustration', COUNT(*) FROM production.Illustration UNION ALL
    SELECT 'production', 'Location', COUNT(*) FROM production.Location UNION ALL
    SELECT 'production', 'Product', COUNT(*) FROM production.Product UNION ALL
    SELECT 'production', 'ProductCategory', COUNT(*) FROM production.ProductCategory UNION ALL
    SELECT 'production', 'ProductCostHistory', COUNT(*) FROM production.ProductCostHistory UNION ALL
    SELECT 'production', 'ProductDescription', COUNT(*) FROM production.ProductDescription UNION ALL
    SELECT 'production', 'ProductDocument', COUNT(*) FROM production.ProductDocument UNION ALL
    SELECT 'production', 'ProductInventory', COUNT(*) FROM production.ProductInventory UNION ALL
    SELECT 'production', 'ProductListPriceHistory', COUNT(*) FROM production.ProductListPriceHistory UNION ALL
    SELECT 'production', 'ProductModel', COUNT(*) FROM production.ProductModel UNION ALL
    SELECT 'production', 'ProductModelIllustration', COUNT(*) FROM production.ProductModelIllustration UNION ALL
    SELECT 'production', 'ProductModelProductDescriptionCulture', COUNT(*) FROM production.ProductModelProductDescriptionCulture UNION ALL
    SELECT 'production', 'ProductPhoto', COUNT(*) FROM production.ProductPhoto UNION ALL
    SELECT 'production', 'ProductProductPhoto', COUNT(*) FROM production.ProductProductPhoto UNION ALL
    SELECT 'production', 'ProductReview', COUNT(*) FROM production.ProductReview UNION ALL
    SELECT 'production', 'ProductSubcategory', COUNT(*) FROM production.ProductSubcategory UNION ALL
    SELECT 'production', 'ScrapReason', COUNT(*) FROM production.ScrapReason UNION ALL
    SELECT 'production', 'TransactionHistory', COUNT(*) FROM production.TransactionHistory UNION ALL
    SELECT 'production', 'TransactionHistoryArchive', COUNT(*) FROM production.TransactionHistoryArchive UNION ALL
    SELECT 'production', 'UnitMeasure', COUNT(*) FROM production.UnitMeasure UNION ALL
    SELECT 'production', 'WorkOrder', COUNT(*) FROM production.WorkOrder UNION ALL
    SELECT 'production', 'WorkOrderRouting', COUNT(*) FROM production.WorkOrderRouting UNION ALL
    SELECT 'purchasing', 'ProductVendor', COUNT(*) FROM purchasing.ProductVendor UNION ALL
    SELECT 'purchasing', 'PurchaseOrderDetail', COUNT(*) FROM purchasing.PurchaseOrderDetail UNION ALL
    SELECT 'purchasing', 'PurchaseOrderHeader', COUNT(*) FROM purchasing.PurchaseOrderHeader UNION ALL
    SELECT 'purchasing', 'ShipMethod', COUNT(*) FROM purchasing.ShipMethod UNION ALL
    SELECT 'purchasing', 'Vendor', COUNT(*) FROM purchasing.Vendor UNION ALL
    SELECT 'sales', 'CountryRegionCurrency', COUNT(*) FROM sales.CountryRegionCurrency UNION ALL
    SELECT 'sales', 'CreditCard', COUNT(*) FROM sales.CreditCard UNION ALL
    SELECT 'sales', 'Currency', COUNT(*) FROM sales.Currency UNION ALL
    SELECT 'sales', 'CurrencyRate', COUNT(*) FROM sales.CurrencyRate UNION ALL
    SELECT 'sales', 'Customer', COUNT(*) FROM sales.Customer UNION ALL
    SELECT 'sales', 'PersonCreditCard', COUNT(*) FROM sales.PersonCreditCard UNION ALL
    SELECT 'sales', 'SalesOrderDetail', COUNT(*) FROM sales.SalesOrderDetail UNION ALL
    SELECT 'sales', 'SalesOrderHeader', COUNT(*) FROM sales.SalesOrderHeader UNION ALL
    SELECT 'sales', 'SalesOrderHeaderSalesReason', COUNT(*) FROM sales.SalesOrderHeaderSalesReason UNION ALL
    SELECT 'sales', 'SalesPerson', COUNT(*) FROM sales.SalesPerson UNION ALL
    SELECT 'sales', 'SalesPersonQuotaHistory', COUNT(*) FROM sales.SalesPersonQuotaHistory UNION ALL
    SELECT 'sales', 'SalesReason', COUNT(*) FROM sales.SalesReason UNION ALL
    SELECT 'sales', 'SalesTaxRate', COUNT(*) FROM sales.SalesTaxRate UNION ALL
    SELECT 'sales', 'SalesTerritory', COUNT(*) FROM sales.SalesTerritory UNION ALL
    SELECT 'sales', 'SalesTerritoryHistory', COUNT(*) FROM sales.SalesTerritoryHistory UNION ALL
    SELECT 'sales', 'ShoppingCartItem', COUNT(*) FROM sales.ShoppingCartItem UNION ALL
    SELECT 'sales', 'SpecialOffer', COUNT(*) FROM sales.SpecialOffer UNION ALL
    SELECT 'sales', 'SpecialOfferProduct', COUNT(*) FROM sales.SpecialOfferProduct UNION ALL
    SELECT 'sales', 'Store', COUNT(*) FROM sales.Store
)
SELECT 
    e.SchemaName,
    e.TableName,
    e.ExpectedCount,
    a.ActualCount,
    CASE 
        WHEN a.ActualCount = e.ExpectedCount THEN 'PASS'
        WHEN a.ActualCount > 0 THEN 'CHECK'
        ELSE 'FAIL'
    END AS Status
FROM ExpectedCounts e
LEFT JOIN ActualCounts a ON e.SchemaName = a.SchemaName AND e.TableName = a.TableName
ORDER BY e.SchemaName, e.TableName;
