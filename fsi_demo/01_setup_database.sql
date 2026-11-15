-- 01_setup_database.sql
-- Purpose: Setup Schema, Sequences, and Macros for FSI Demo in DuckDB
-- Source: Financial Services Industry Demo Database

PRAGMA enable_progress_bar;

-- Schemas
CREATE SCHEMA IF NOT EXISTS main;
CREATE SCHEMA IF NOT EXISTS public;

-- Sequences for Primary Keys
CREATE SEQUENCE IF NOT EXISTS seq_asset_info START 1;
CREATE SEQUENCE IF NOT EXISTS seq_pricing_info START 1;
CREATE SEQUENCE IF NOT EXISTS seq_account_info START 1;
CREATE SEQUENCE IF NOT EXISTS seq_portfolio START 1;
CREATE SEQUENCE IF NOT EXISTS seq_portfolio_asset_map START 1;
CREATE SEQUENCE IF NOT EXISTS seq_transaction_info START 1;

-- UDF / Macro: get_random_date
-- Returns a random date within a specified interval
CREATE OR REPLACE MACRO get_random_date(inter := 7300, period := 'random', date_data := CURRENT_DATE) AS (
    CASE 
        WHEN period = 'past' THEN date_data - CAST(FLOOR(random() * inter) AS INTEGER)
        WHEN period = 'future' THEN date_data + CAST(FLOOR(random() * inter) AS INTEGER)
        ELSE date_data + CAST(FLOOR((random() - 0.5) * 2 * inter) AS INTEGER)
    END
);
