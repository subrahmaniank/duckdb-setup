"""Build a deterministic, synthetic auto finance DuckDB demo database."""

import argparse
from pathlib import Path

import duckdb


SCHEMA = """
CREATE SCHEMA lending;

CREATE TABLE lending.dealers AS
SELECT dealer_id, 'Dealer ' || lpad(dealer_id::VARCHAR, 3, '0') AS dealer_name,
       ['Northeast', 'South', 'Midwest', 'West'][1 + dealer_id % 4] AS region
FROM range(1, 61) AS t(dealer_id);

CREATE TABLE lending.applications AS
SELECT application_id,
       DATE '2024-01-01' + ((application_id * 17) % 900)::INTEGER AS application_date,
       1 + (application_id % 60) AS dealer_id,
       CASE WHEN application_id % 5 = 0 THEN 'declined' ELSE 'approved' END AS decision,
       CASE WHEN application_id % 7 IN (0, 1) THEN 'nonprime' ELSE 'prime' END AS credit_tier,
       CASE WHEN application_id % 3 = 0 THEN 'new' ELSE 'used' END AS vehicle_type,
       (18000 + (application_id * 137) % 36000)::DECIMAL(12,2) AS vehicle_value,
       (1000 + (application_id * 71) % 7000)::DECIMAL(12,2) AS down_payment,
       CASE WHEN application_id % 9 = 0 THEN (1200 + (application_id * 31) % 6500)::DECIMAL(12,2)
            ELSE 0::DECIMAL(12,2) END AS trade_in_negative_equity
FROM range(1, 30001) AS t(application_id);

CREATE TABLE lending.loans AS
WITH terms AS (
  SELECT a.application_id AS loan_id, a.application_id, a.dealer_id,
         a.application_date + 3 AS origination_date, a.credit_tier, a.vehicle_type,
         a.vehicle_value, a.down_payment, a.trade_in_negative_equity,
         (a.vehicle_value - a.down_payment + a.trade_in_negative_equity)::DECIMAL(12,2) AS amount_financed,
         CASE WHEN a.credit_tier = 'nonprime' THEN 12.5 ELSE 7.5 END
           + (a.application_id % 5) * 0.35 AS apr_pct,
         CASE WHEN a.application_id % 4 = 0 THEN 72 ELSE 60 END AS term_months
  FROM lending.applications a WHERE a.decision = 'approved'
)
SELECT *, ROUND(amount_financed * (apr_pct / 1200.0) /
       (1 - POW(1 + apr_pct / 1200.0, -term_months)), 2)::DECIMAL(12,2) AS monthly_payment,
       ROUND(amount_financed * 100.0 / vehicle_value, 2) AS origination_ltv_pct
FROM terms;

CREATE TABLE lending.monthly_performance AS
WITH months AS (
  SELECT month_index,
         last_day(DATE '2024-01-01' + month_index * INTERVAL '1 month') AS snapshot_date
  FROM range(0, 34) AS t(month_index)
), eligible AS (
  SELECT l.loan_id, l.origination_date, l.amount_financed, l.monthly_payment,
         l.credit_tier, m.snapshot_date, m.month_index,
         date_diff('month', date_trunc('month', l.origination_date), date_trunc('month', m.snapshot_date)) AS months_on_book,
         hash(l.loan_id, m.month_index) % 100 AS risk_draw
  FROM lending.loans l CROSS JOIN months m
  WHERE m.snapshot_date >= l.origination_date
)
SELECT loan_id, snapshot_date, months_on_book,
       CASE WHEN months_on_book >= 18 AND loan_id % 19 = 0 THEN 'paid_off'
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 5 ELSE 2 END THEN '60_plus'
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 13 ELSE 5 END THEN '30_59'
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 25 ELSE 12 END THEN '1_29'
            ELSE 'current' END AS delinquency_bucket,
       CASE WHEN months_on_book >= 18 AND loan_id % 19 = 0 THEN 0
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 5 ELSE 2 END THEN 60
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 13 ELSE 5 END THEN 30
            WHEN risk_draw < CASE WHEN credit_tier = 'nonprime' THEN 25 ELSE 12 END THEN 10
            ELSE 0 END AS days_past_due,
       CASE WHEN months_on_book >= 18 AND loan_id % 19 = 0 THEN 0
            ELSE GREATEST(0, ROUND(amount_financed - monthly_payment * months_on_book * 0.69, 2)) END::DECIMAL(12,2)
            AS outstanding_balance
FROM eligible;

CREATE TABLE lending.payments AS
SELECT p.loan_id, p.snapshot_date AS installment_month,
       p.snapshot_date - INTERVAL '5 days' AS due_date,
       CASE WHEN p.days_past_due >= 30 OR p.delinquency_bucket = 'paid_off' THEN NULL
            ELSE p.snapshot_date - INTERVAL '5 days' + p.days_past_due * INTERVAL '1 day' END AS payment_date,
       l.monthly_payment AS amount_due,
       CASE WHEN p.days_past_due >= 30 OR p.delinquency_bucket = 'paid_off' THEN 0
            ELSE l.monthly_payment END AS amount_paid
FROM lending.monthly_performance p JOIN lending.loans l USING (loan_id);

CREATE TABLE lending.collections AS
SELECT p.loan_id, p.snapshot_date AS contact_date,
       CASE WHEN p.loan_id % 3 = 0 THEN 'phone' ELSE 'sms' END AS channel,
       CASE WHEN p.loan_id % 4 = 0 THEN 'promise_to_pay' ELSE 'contacted' END AS outcome
FROM lending.monthly_performance p WHERE p.days_past_due >= 30;

CREATE TABLE lending.add_on_products AS
SELECT l.loan_id, CASE WHEN l.loan_id % 2 = 0 THEN 'GAP' ELSE 'service_contract' END AS product_type,
       (600 + l.loan_id % 900)::DECIMAL(12,2) AS price,
       CASE WHEN l.loan_id % 19 = 0 THEN l.origination_date + INTERVAL '18 months' ELSE NULL END AS cancellation_date,
       CASE WHEN l.loan_id % 19 = 0 THEN (200 + l.loan_id % 300)::DECIMAL(12,2) ELSE 0 END AS refund_due,
       CASE WHEN l.loan_id % 19 = 0 AND l.loan_id % 3 = 0 THEN 0::DECIMAL(12,2)
            WHEN l.loan_id % 19 = 0 THEN (200 + l.loan_id % 300)::DECIMAL(12,2)
            ELSE 0::DECIMAL(12,2) END AS refund_paid
FROM lending.loans l WHERE l.loan_id % 5 = 1;
"""


def build_database(output: Path | None = None, *, force: bool = False) -> int:
    output = (output or Path(__file__).with_name("auto_finance.duckdb")).resolve()
    if output.exists() and not force:
        raise FileExistsError(f"Database exists: {output}. Pass --force to rebuild it.")
    output.parent.mkdir(parents=True, exist_ok=True)
    if output.exists():
        output.unlink()
    connection = duckdb.connect(str(output))
    try:
        connection.execute(SCHEMA)
        counts = connection.execute("""
            SELECT table_name, estimated_size
            FROM duckdb_tables() WHERE schema_name = 'lending' ORDER BY table_name
        """).fetchall()
        for table, count in counts:
            print(f"{table}: {count:,} rows")
    finally:
        connection.close()
    print(f"Created {output}")
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path(__file__).with_name("auto_finance.duckdb"))
    parser.add_argument("--force", action="store_true", help="replace an existing database")
    arguments = parser.parse_args()
    build_database(arguments.output, force=arguments.force)
