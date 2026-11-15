# Financial Services Industry (FSI / SEI) Demo Database for DuckDB

This package builds and loads the Financial Services Industry (FSI) sample database into a local, high-performance [DuckDB](https://duckdb.org/) database (`fsi_demo.duckdb` and `sei_demo.duckdb`).

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
1. Verify or copy required CSV data files into `data/`
2. Create sequences, schemas, and the `get_random_date` macro
3. Create all 8 tables
4. Load all 640,000+ records
5. Run the transaction calculation updates
6. Validate row counts against expected metrics

## Tables Included

| Table Name | Description | Expected Rows |
|---|---|---|
| `Asset_Info` | Assets, tickers, Cusip identifiers, and scrip names | 10 |
| `Pricing_Info` | Daily and interval price updates (open, high, low, volume) | 2,516 |
| `Historical_Pricing_Info` | Multi-year historical pricing | 2,516 |
| `account_info` | Customer accounts, start/end dates, and tax IDs | 100 |
| `portfolio` | Investment portfolios associated with accounts | 300 |
| `portfolio_asset_map` | Mapping linking portfolios to securities | 2,500 |
| `transaction_info` | Buy/sell transactions with calculated fees and taxes | 629,011 |
| `generated_name_info` | Synthetic customer names for demos | 5,000 |

## Querying DuckDB

```python
import duckdb

conn = duckdb.connect("fsi_demo.duckdb")

# Top 5 portfolios by transaction volume
df = conn.execute("""
    SELECT 
        p.portfolio_name,
        COUNT(t.transaction_info_id) AS total_transactions,
        SUM(t.transaction_price) AS total_traded_value
    FROM portfolio p
    JOIN portfolio_asset_map pam ON p.portfolio_id = pam.portfolio_id
    JOIN transaction_info t ON pam.portfolio_asset_map_id = t.portfolio_asset_map_id
    GROUP BY p.portfolio_name
    ORDER BY total_traded_value DESC
    LIMIT 5;
""").df()

print(df)
```
