-- 04_validate_data.sql
-- Purpose: Validate row counts for FSI Demo tables in DuckDB

CREATE OR REPLACE TEMP TABLE ExpectedCounts (
    TableName VARCHAR,
    ExpectedCount BIGINT
);

INSERT INTO ExpectedCounts VALUES
('Asset_Info', 10),
('Pricing_Info', 2516),
('Historical_Pricing_Info', 2516),
('account_info', 100),
('portfolio', 300),
('portfolio_asset_map', 2500),
('transaction_info', 629011),
('generated_name_info', 5000);

WITH ActualCounts AS (
    SELECT 'Asset_Info' AS TableName, COUNT(*) AS ActualCount FROM Asset_Info UNION ALL
    SELECT 'Pricing_Info', COUNT(*) FROM Pricing_Info UNION ALL
    SELECT 'Historical_Pricing_Info', COUNT(*) FROM Historical_Pricing_Info UNION ALL
    SELECT 'account_info', COUNT(*) FROM account_info UNION ALL
    SELECT 'portfolio', COUNT(*) FROM portfolio UNION ALL
    SELECT 'portfolio_asset_map', COUNT(*) FROM portfolio_asset_map UNION ALL
    SELECT 'transaction_info', COUNT(*) FROM transaction_info UNION ALL
    SELECT 'generated_name_info', COUNT(*) FROM generated_name_info
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
