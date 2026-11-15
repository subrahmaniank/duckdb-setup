# DVD Rental Sample Database for DuckDB

This package builds and loads the classic DVD Rental sample database (originally from PostgreSQL) into a local, high-performance [DuckDB](https://duckdb.org/) database (`dvdrental.duckdb`).

## Quick Start

### Build the Database

**Using PowerShell:**
```powershell
.\deploy.ps1
```

**Using Bash:**
```bash
./deploy.sh
```

**Using Python:**
```bash
python build.py
# or with uv:
uv run --with duckdb python build.py
```

This will automatically:
1. Verify or download the required CSV data files into `data/`
2. Create `dvdrental.duckdb`
3. Execute schemas and table DDL
4. Load all 15 tables using DuckDB's vectorized CSV loader
5. Validate row counts against expected metrics

## Tables Included

| Table Name | Description | Expected Rows |
|---|---|---|
| `actor` | Actors participating in films | 200 |
| `category` | Movie genres / categories | 16 |
| `language` | Film audio languages | 6 |
| `country` | Countries | 109 |
| `city` | Cities | 600 |
| `address` | Addresses for stores, staff, and customers | 603 |
| `film` | Movie catalogue with descriptions and ratings | 1,000 |
| `film_actor` | Many-to-many map between films and actors | 5,462 |
| `film_category` | Many-to-many map between films and categories | 1,000 |
| `staff` | Store staff and employees | 2 |
| `store` | Physical rental store locations | 2 |
| `customer` | Registered rental customers | 599 |
| `inventory` | Individual physical inventory copies of films | 4,581 |
| `rental` | Rental checkout and return transaction history | 16,044 |
| `payment` | Customer payments for rentals | 14,596 |

## Querying DuckDB

```python
import duckdb

conn = duckdb.connect("dvdrental.duckdb")

# Top 5 most rented films
df = conn.execute("""
    SELECT f.title, COUNT(r.rental_id) AS rental_count
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.title
    ORDER BY rental_count DESC
    LIMIT 5;
""").df()

print(df)
```
