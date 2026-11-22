# Auto Finance synthetic DuckDB setup

Build a reproducible, synthetic auto loan portfolio for the sibling
`vanna-samples/auto_finance` app. The database contains no customer PII.

From this repository root:

```powershell
uv run python auto_finance/build.py
```

The output is `auto_finance/auto_finance.duckdb`. Use `--force` to rebuild an
existing file, then copy it to `../vanna-samples/auto_finance/auto_finance.duckdb`.
The repository's `deploy_all.py --databases auto_finance` also rebuilds it.

The database contains seven `lending` tables: `dealers`, `applications`,
`loans`, `monthly_performance`, `payments`, `collections`, and
`add_on_products`. The dataset has 30,000 applications, 24,000 originated
loans, and monthly records through 2026-10-31. It is deterministic, so the
same build produces the same analysis results.
