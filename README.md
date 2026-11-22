# DuckDB Sample Databases Setup

A comprehensive, production-ready suite of sample databases built for [DuckDB](https://duckdb.org/), matching the architectures in `snowflake-setup` and `postgres-setup`:

1. **AdventureWorks OLTP** (`adventureworks_oltp` / `adventureworks`) - Complete relational enterprise schema with 68 tables across 5 schemas (`person`, `humanresources`, `production`, `purchasing`, `sales`).
2. **AdventureWorks Data Warehouse** (`adventureworks_dw`) - Star schema data warehouse with 29 tables (Fact & Dimension tables, 1,000,000+ records).
3. **DVD Rental** (`dvdrental`) - The standard PostgreSQL sample database with 15 tables.
4. **FSI Demo** (`fsi_demo` / `sei_demo`) - Financial Services Industry investment portfolio, asset pricing, and transaction history database (640,000+ records).
5. **Auto Finance** (`auto_finance`) - Synthetic loan originations, dealers, monthly performance, payments, collections, and add-on products.

---

## Repository Structure

```
duckdb-setup/
├── deploy_all.py                 # Cross-platform master build & validation script
├── deploy_all.ps1                # PowerShell master deployment script
├── deploy_all.sh                 # Bash master deployment script
├── requirements.txt              # Python dependencies (duckdb, pandas)
├── pyproject.toml                # Project metadata
├── README.md                     # Documentation
│
├── adventureworks_dw/            # AdventureWorks Data Warehouse (29 tables)
│   ├── 01_setup_database.sql     # Schemas & options
│   ├── 02_create_tables.sql      # DuckDB DDL
│   ├── 03_load_data.sql          # Ingestion statements
│   ├── 04_validate_data.sql      # Row count validation
│   ├── build.py                  # Self-contained build script
│   ├── deploy.ps1                # PowerShell deployer
│   ├── deploy.sh                 # Bash deployer
│   ├── download_data.py          # Data downloader / local copier
│   ├── download_data.ps1         # PowerShell downloader
│   ├── download_data.sh          # Bash downloader
│   └── README.md
│
├── adventureworks_oltp/          # AdventureWorks OLTP (68 tables, 5 schemas)
│   ├── 01_setup_database.sql     # Schemas (person, humanresources, production, purchasing, sales)
│   ├── 02_create_tables.sql      # Complete DuckDB DDL
│   ├── 03_load_data.sql          # Ingestion statements
│   ├── 04_validate_data.sql      # Validation against 68 tables
│   ├── build.py                  # Self-contained build script (creates companion adventureworks.duckdb)
│   ├── deploy.ps1
│   ├── deploy.sh
│   ├── download_data.py
│   ├── download_data.ps1
│   ├── download_data.sh
│   └── README.md
│
├── dvdrental/                    # DVD Rental (15 tables)
│   ├── 01_setup_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_load_data.sql
│   ├── 04_validate_data.sql
│   ├── build.py
│   ├── deploy.ps1
│   ├── deploy.sh
│   ├── download_data.py
│   ├── download_data.ps1
│   ├── download_data.sh
│   └── README.md
│
└── fsi_demo/                     # Financial Services Industry Demo (8 tables)
    ├── 01_setup_database.sql     # Sequences, schemas, and get_random_date macro
    ├── 02_create_tables.sql
    ├── 03_load_data.sql          # Ingestion and transaction calculation updates
    ├── 04_validate_data.sql
    ├── build.py                  # Self-contained build script (creates companion sei_demo.duckdb)
    ├── deploy.ps1
    ├── deploy.sh
    ├── download_data.py
    ├── download_data.ps1
    ├── download_data.sh
    └── README.md
```

---

## Quick Start

### 1. Requirements

Install DuckDB:
```bash
pip install -r requirements.txt
# or using uv:
uv pip install -r requirements.txt
```

### 2. Deploy All Databases

To build all 5 databases simultaneously:

**PowerShell (Windows):**
```powershell
.\deploy_all.ps1
```

**Bash (Linux / macOS):**
```bash
./deploy_all.sh
```

**Python (Cross-Platform):**
```bash
python deploy_all.py
# or with uv:
uv run --with duckdb python deploy_all.py
```

### 3. Deploy Specific Databases

You can deploy one or a subset of databases:

```powershell
.\deploy_all.ps1 -Databases "dvdrental,fsi_demo"
```
or:
```bash
python deploy_all.py --databases "adventureworks_oltp,adventureworks_dw"
```

---

## Database Summary & Verification

| Database | Schema(s) | Table Count | Total Rows | Target File |
|---|---|---|---|---|
| **DVD Rental** | `main`, `public` | 15 | 45,395 | `dvdrental/dvdrental.duckdb` |
| **FSI Demo** | `main`, `public` | 8 | 642,443 | `fsi_demo/fsi_demo.duckdb` (alias: `sei_demo.duckdb`) |
| **AdventureWorks DW** | `main`, `public` | 29 | 1,061,940 | `adventureworks_dw/adventureworks_dw.duckdb` |
| **AdventureWorks OLTP** | `person`, `humanresources`, `production`, `purchasing`, `sales` | 68 | 614,849 | `adventureworks_oltp/adventureworks_oltp.duckdb` (alias: `adventureworks.duckdb`) |
| **Auto Finance** | `lending` | 7 | 1,034,484 | `auto_finance/auto_finance.duckdb` |

All databases load and validate in seconds thanks to DuckDB's vectorized query engine and columnar storage format.

---

## Using with Python

```python
import duckdb

# Connect to DVD Rental
conn = duckdb.connect("dvdrental/dvdrental.duckdb", read_only=True)
top_films = conn.execute("""
    SELECT f.title, COUNT(r.rental_id) AS rentals
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.title
    ORDER BY rentals DESC
    LIMIT 5;
""").df()
print(top_films)

# Connect to AdventureWorks OLTP
conn_aw = duckdb.connect("adventureworks_oltp/adventureworks_oltp.duckdb", read_only=True)
top_sales = conn_aw.execute("""
    SELECT 
        p.Name AS ProductName,
        SUM(d.LineTotal) AS Revenue
    FROM sales.SalesOrderDetail d
    JOIN production.Product p ON d.ProductID = p.ProductID
    GROUP BY p.Name
    ORDER BY Revenue DESC
    LIMIT 5;
""").df()
print(top_sales)
```

---

## Using with Vanna AI Samples

If using with `vanna-samples`:
- Store Analyzer: set `DATABASE_TYPE=duckdb` and `DUCKDB_PATH=adventureworks_oltp/adventureworks.duckdb`
- DVD Rental Analyzer: set `DATABASE_TYPE=duckdb` and `DUCKDB_PATH=dvdrental/dvdrental.duckdb`
- Portfolio Analyzer: set `DATABASE_TYPE=duckdb` and `DUCKDB_PATH=fsi_demo/sei_demo.duckdb`
