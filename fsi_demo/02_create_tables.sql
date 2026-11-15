-- 02_create_tables.sql
-- Purpose: Create tables for FSI Demo database in DuckDB
-- Source: Financial Services Industry Demo Database

-- 1. Asset_Info
CREATE TABLE IF NOT EXISTS Asset_Info (
    Asset_Info_ID INTEGER DEFAULT nextval('seq_asset_info') PRIMARY KEY,
    Ticker VARCHAR NOT NULL,
    Cusip VARCHAR NOT NULL,
    Scrip_Name VARCHAR NOT NULL
);

-- 2. Pricing_Info
CREATE TABLE IF NOT EXISTS Pricing_Info (
    Pricing_Info_ID INTEGER DEFAULT nextval('seq_pricing_info') PRIMARY KEY,
    Asset_Info_ID INTEGER,
    Pricing_Date VARCHAR NOT NULL,
    Last_Traded_Price DOUBLE NOT NULL,
    Volume DOUBLE,
    Open_Price DOUBLE,
    High_Price DOUBLE,
    Low_Price DOUBLE
);

-- 3. Historical_Pricing_Info
CREATE TABLE IF NOT EXISTS Historical_Pricing_Info (
    Pricing_Date DATE NOT NULL,
    Last_Traded_Price DOUBLE NOT NULL,
    Volume BIGINT,
    Open DOUBLE,
    High DOUBLE,
    Low DOUBLE,
    Ticker VARCHAR,
    Cusip VARCHAR,
    Scrip_Name VARCHAR
);

-- 4. account_info
CREATE TABLE IF NOT EXISTS account_info (
    account_id INTEGER DEFAULT nextval('seq_account_info') PRIMARY KEY,
    account_name VARCHAR,
    account_start_date DATE,
    account_end_date DATE,
    account_status VARCHAR,
    primary_owner_tax_id VARCHAR
);

-- 5. portfolio
CREATE TABLE IF NOT EXISTS portfolio (
    portfolio_id INTEGER DEFAULT nextval('seq_portfolio') PRIMARY KEY,
    portfolio_name VARCHAR,
    account_id INTEGER
);

-- 6. portfolio_asset_map
CREATE TABLE IF NOT EXISTS portfolio_asset_map (
    portfolio_asset_map_id INTEGER DEFAULT nextval('seq_portfolio_asset_map') PRIMARY KEY,
    portfolio_id INTEGER,
    asset_info_id INTEGER
);

-- 7. transaction_info
CREATE TABLE IF NOT EXISTS transaction_info (
    transaction_info_id INTEGER DEFAULT nextval('seq_transaction_info') PRIMARY KEY,
    portfolio_asset_map_id INTEGER,
    transaction_date DATE,
    quantity DOUBLE,
    transaction_price DOUBLE,
    transaction_fee DOUBLE,
    transaction_tax DOUBLE,
    settlement_date DATE,
    transaction_description VARCHAR,
    performed_by_user VARCHAR,
    transaction_status VARCHAR
);

-- 8. generated_name_info
CREATE TABLE IF NOT EXISTS generated_name_info (
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    full_name VARCHAR
);
