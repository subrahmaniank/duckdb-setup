-- 01_setup_database.sql
-- Purpose: Setup Schema and Settings for AdventureWorksDW in DuckDB
-- Source: AdventureWorks Data Warehouse Sample Database

PRAGMA enable_progress_bar;

CREATE SCHEMA IF NOT EXISTS main;
CREATE SCHEMA IF NOT EXISTS public;
