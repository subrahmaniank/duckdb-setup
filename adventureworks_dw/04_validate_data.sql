-- 04_validate_data.sql
-- Purpose: Validate row counts for AdventureWorksDW tables in DuckDB

CREATE OR REPLACE TEMP TABLE ExpectedCounts (
    TableName VARCHAR,
    ExpectedCount BIGINT
);

INSERT INTO ExpectedCounts VALUES
('DatabaseLog', 112),
('DimAccount', 99),
('DimCurrency', 105),
('DimCustomer', 18484),
('DimDate', 3652),
('DimDepartmentGroup', 7),
('DimEmployee', 296),
('DimGeography', 655),
('DimOrganization', 14),
('DimProduct', 606),
('DimProductCategory', 4),
('DimProductSubcategory', 37),
('DimPromotion', 16),
('DimReseller', 701),
('DimSalesReason', 10),
('DimSalesTerritory', 11),
('DimScenario', 3),
('FactAdditionalInternationalProductDescription', 1911),
('FactCallCenter', 120),
('FactCurrencyRate', 14264),
('FactFinance', 39409),
('FactInternetSales', 60398),
('FactInternetSalesReason', 64515),
('FactProductInventory', 776286),
('FactResellerSales', 60855),
('FactSalesQuota', 163),
('FactSurveyResponse', 2727),
('NewFactCurrencyRate', 50),
('ProspectiveBuyer', 2059);

WITH ActualCounts AS (
    SELECT 'DatabaseLog' AS TableName, COUNT(*) AS ActualCount FROM DatabaseLog UNION ALL
    SELECT 'DimAccount', COUNT(*) FROM DimAccount UNION ALL
    SELECT 'DimCurrency', COUNT(*) FROM DimCurrency UNION ALL
    SELECT 'DimCustomer', COUNT(*) FROM DimCustomer UNION ALL
    SELECT 'DimDate', COUNT(*) FROM DimDate UNION ALL
    SELECT 'DimDepartmentGroup', COUNT(*) FROM DimDepartmentGroup UNION ALL
    SELECT 'DimEmployee', COUNT(*) FROM DimEmployee UNION ALL
    SELECT 'DimGeography', COUNT(*) FROM DimGeography UNION ALL
    SELECT 'DimOrganization', COUNT(*) FROM DimOrganization UNION ALL
    SELECT 'DimProduct', COUNT(*) FROM DimProduct UNION ALL
    SELECT 'DimProductCategory', COUNT(*) FROM DimProductCategory UNION ALL
    SELECT 'DimProductSubcategory', COUNT(*) FROM DimProductSubcategory UNION ALL
    SELECT 'DimPromotion', COUNT(*) FROM DimPromotion UNION ALL
    SELECT 'DimReseller', COUNT(*) FROM DimReseller UNION ALL
    SELECT 'DimSalesReason', COUNT(*) FROM DimSalesReason UNION ALL
    SELECT 'DimSalesTerritory', COUNT(*) FROM DimSalesTerritory UNION ALL
    SELECT 'DimScenario', COUNT(*) FROM DimScenario UNION ALL
    SELECT 'FactAdditionalInternationalProductDescription', COUNT(*) FROM FactAdditionalInternationalProductDescription UNION ALL
    SELECT 'FactCallCenter', COUNT(*) FROM FactCallCenter UNION ALL
    SELECT 'FactCurrencyRate', COUNT(*) FROM FactCurrencyRate UNION ALL
    SELECT 'FactFinance', COUNT(*) FROM FactFinance UNION ALL
    SELECT 'FactInternetSales', COUNT(*) FROM FactInternetSales UNION ALL
    SELECT 'FactInternetSalesReason', COUNT(*) FROM FactInternetSalesReason UNION ALL
    SELECT 'FactProductInventory', COUNT(*) FROM FactProductInventory UNION ALL
    SELECT 'FactResellerSales', COUNT(*) FROM FactResellerSales UNION ALL
    SELECT 'FactSalesQuota', COUNT(*) FROM FactSalesQuota UNION ALL
    SELECT 'FactSurveyResponse', COUNT(*) FROM FactSurveyResponse UNION ALL
    SELECT 'NewFactCurrencyRate', COUNT(*) FROM NewFactCurrencyRate UNION ALL
    SELECT 'ProspectiveBuyer', COUNT(*) FROM ProspectiveBuyer
)
SELECT 
    e.TableName,
    e.ExpectedCount,
    a.ActualCount,
    CASE 
        WHEN a.ActualCount = e.ExpectedCount THEN 'PASS'
        WHEN a.ActualCount = 0 THEN 'FAIL'
        ELSE 'CHECK'
    END AS Status
FROM ExpectedCounts e
LEFT JOIN ActualCounts a ON e.TableName = a.TableName
ORDER BY e.TableName;
