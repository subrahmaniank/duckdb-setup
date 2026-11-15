-- 01_setup_database.sql
-- Purpose: Setup Schema and Settings for DVD Rental in DuckDB
-- Source: PostgreSQL DVD Rental Sample Database

-- Set DuckDB options
PRAGMA enable_progress_bar;

-- Create Schemas (DuckDB uses 'main' as default schema, also create 'public' for PostgreSQL compatibility)
CREATE SCHEMA IF NOT EXISTS main;
CREATE SCHEMA IF NOT EXISTS public;
