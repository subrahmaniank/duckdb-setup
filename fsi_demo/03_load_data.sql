-- 03_load_data.sql
-- Purpose: Load FSI Demo CSV data into DuckDB tables
-- Note: Paths are relative to database directory (or parameterized by build script)

-- 1. Load reference/lookup tables
INSERT INTO Asset_Info (Ticker, Cusip, Scrip_Name)
SELECT Ticker, Cusip, Scrip_Name FROM read_csv('data/asset_info.csv', header=true);

INSERT INTO generated_name_info (first_name, middle_name, last_name, full_name)
SELECT first_name, middle_name, last_name, full_name FROM read_csv('data/generated_name_info.csv', header=true);

-- 2. Load account data
INSERT INTO account_info (account_name, account_start_date, account_end_date, account_status, primary_owner_tax_id)
SELECT account_name, account_start_date, account_end_date, account_status, primary_owner_tax_id FROM read_csv('data/account_info.csv', header=true);

-- 3. Load pricing data
INSERT INTO Pricing_Info (Asset_Info_ID, Pricing_Date, Last_Traded_Price, Volume, Open_Price, High_Price, Low_Price)
SELECT Asset_Info_ID, Pricing_Date, Last_Traded_Price, Volume, Open_price, High_price, Low_price FROM read_csv('data/pricing_info.csv', header=true);

INSERT INTO Historical_Pricing_Info (Pricing_Date, Last_Traded_Price, Volume, Open, High, Low, Ticker, Cusip, Scrip_Name)
SELECT Pricing_Date, Last_Traded_Price, Volume, Open, High, Low, Ticker, Cusip, Scrip_Name FROM read_csv('data/historic_pricing_info.csv', header=true);

-- 4. Load portfolio data
INSERT INTO portfolio (portfolio_name, account_id)
SELECT portfolio_name, account_id FROM read_csv('data/portfolio.csv', header=true);

-- 5. Load portfolio asset mapping
INSERT INTO portfolio_asset_map (portfolio_id, asset_info_id)
SELECT portfolio_id, asset_info_id FROM read_csv('data/portfolio_asset_map.csv', header=true);

-- 6. Load transaction data
INSERT INTO transaction_info (portfolio_asset_map_id, transaction_date, quantity, transaction_price, transaction_fee, transaction_tax, settlement_date, transaction_description, performed_by_user, transaction_status)
SELECT portfolio_asset_map_id, transaction_date, quantity, transaction_price, transaction_fee, transaction_tax, settlement_date, transaction_description, performed_by_user, transaction_status FROM read_csv('data/transaction_info.csv', header=true);

-- 7. Update transaction_info to populate quantity, fee, and tax calculations
UPDATE transaction_info
SET
    quantity = q.qty,
    transaction_price = q.qty * transaction_info.transaction_price,
    transaction_fee = (q.qty * transaction_info.transaction_price) * 0.3,
    transaction_tax = (q.qty * transaction_info.transaction_price) * 0.1
FROM (
    SELECT transaction_info_id, CAST(FLOOR(random() * 9000 + 1000) AS INTEGER) AS qty
    FROM transaction_info
) q
WHERE transaction_info.transaction_info_id = q.transaction_info_id;
