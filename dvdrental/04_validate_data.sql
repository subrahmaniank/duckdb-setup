-- 04_validate_data.sql
-- Purpose: Validate row counts for DVD Rental tables in DuckDB

CREATE OR REPLACE TEMP TABLE ExpectedCounts (
    TableName VARCHAR,
    ExpectedCount BIGINT
);

INSERT INTO ExpectedCounts VALUES
('actor', 200),
('address', 603),
('category', 16),
('city', 600),
('country', 109),
('customer', 599),
('film', 1000),
('film_actor', 5462),
('film_category', 1000),
('inventory', 4581),
('language', 6),
('payment', 14596),
('rental', 16044),
('staff', 2),
('store', 2);

WITH ActualCounts AS (
    SELECT 'actor' AS TableName, COUNT(*) AS ActualCount FROM actor UNION ALL
    SELECT 'address', COUNT(*) FROM address UNION ALL
    SELECT 'category', COUNT(*) FROM category UNION ALL
    SELECT 'city', COUNT(*) FROM city UNION ALL
    SELECT 'country', COUNT(*) FROM country UNION ALL
    SELECT 'customer', COUNT(*) FROM customer UNION ALL
    SELECT 'film', COUNT(*) FROM film UNION ALL
    SELECT 'film_actor', COUNT(*) FROM film_actor UNION ALL
    SELECT 'film_category', COUNT(*) FROM film_category UNION ALL
    SELECT 'inventory', COUNT(*) FROM inventory UNION ALL
    SELECT 'language', COUNT(*) FROM language UNION ALL
    SELECT 'payment', COUNT(*) FROM payment UNION ALL
    SELECT 'rental', COUNT(*) FROM rental UNION ALL
    SELECT 'staff', COUNT(*) FROM staff UNION ALL
    SELECT 'store', COUNT(*) FROM store
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
