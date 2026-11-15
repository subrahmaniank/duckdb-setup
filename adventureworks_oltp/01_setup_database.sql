-- 01_setup_database.sql
-- Purpose: Setup Schemas and Settings for AdventureWorks OLTP in DuckDB
-- Source: AdventureWorks OLTP Sample Database

PRAGMA enable_progress_bar;

-- Create Schemas matching SQL Server / Snowflake / PostgreSQL
CREATE SCHEMA IF NOT EXISTS humanresources;
CREATE SCHEMA IF NOT EXISTS person;
CREATE SCHEMA IF NOT EXISTS production;
CREATE SCHEMA IF NOT EXISTS purchasing;
CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS public;
