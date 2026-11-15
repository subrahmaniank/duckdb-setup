-- 02_create_tables.sql
-- Purpose: Create tables for DVD Rental database in DuckDB
-- Source: PostgreSQL DVD Rental Sample Database

-- =============================================
-- Reference/Lookup Tables
-- =============================================

CREATE TABLE IF NOT EXISTS actor (
    actor_id INTEGER NOT NULL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS category (
    category_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS language (
    language_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    last_update TIMESTAMP NOT NULL
);

-- =============================================
-- Geographic Hierarchy Tables
-- =============================================

CREATE TABLE IF NOT EXISTS country (
    country_id INTEGER NOT NULL PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS city (
    city_id INTEGER NOT NULL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    country_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS address (
    address_id INTEGER NOT NULL PRIMARY KEY,
    address VARCHAR(50) NOT NULL,
    address2 VARCHAR(50),
    district VARCHAR(20),
    city_id INTEGER NOT NULL,
    postal_code VARCHAR(10),
    phone VARCHAR(20),
    last_update TIMESTAMP NOT NULL
);

-- =============================================
-- Film Tables
-- =============================================

CREATE TABLE IF NOT EXISTS film (
    film_id INTEGER NOT NULL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR,
    release_year INTEGER,
    language_id INTEGER NOT NULL,
    rental_duration INTEGER NOT NULL DEFAULT 3,
    rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
    length INTEGER,
    replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
    rating VARCHAR(10),
    last_update TIMESTAMP NOT NULL,
    special_features VARCHAR,
    fulltext VARCHAR
);

CREATE TABLE IF NOT EXISTS film_actor (
    actor_id INTEGER NOT NULL,
    film_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL,
    PRIMARY KEY (actor_id, film_id)
);

CREATE TABLE IF NOT EXISTS film_category (
    film_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL,
    PRIMARY KEY (film_id, category_id)
);

-- =============================================
-- Organizational Tables
-- =============================================

CREATE TABLE IF NOT EXISTS staff (
    staff_id INTEGER NOT NULL PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address_id INTEGER NOT NULL,
    email VARCHAR(50),
    store_id INTEGER NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    username VARCHAR(16) NOT NULL,
    password VARCHAR(40),
    last_update TIMESTAMP NOT NULL,
    picture VARCHAR
);

CREATE TABLE IF NOT EXISTS store (
    store_id INTEGER NOT NULL PRIMARY KEY,
    manager_staff_id INTEGER NOT NULL,
    address_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS customer (
    customer_id INTEGER NOT NULL PRIMARY KEY,
    store_id INTEGER NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address_id INTEGER NOT NULL,
    activebool BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATE NOT NULL,
    last_update TIMESTAMP,
    active INTEGER
);

-- =============================================
-- Inventory & Transactions
-- =============================================

CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INTEGER NOT NULL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    store_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS rental (
    rental_id INTEGER NOT NULL PRIMARY KEY,
    rental_date TIMESTAMP NOT NULL,
    inventory_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    return_date TIMESTAMP,
    staff_id INTEGER NOT NULL,
    last_update TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS payment (
    payment_id INTEGER NOT NULL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    rental_id INTEGER NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL
);
