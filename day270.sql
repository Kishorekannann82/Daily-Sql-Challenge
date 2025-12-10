/*
Normalize Revenue to a Single Currency Using Exchange Rates
Scenario

You store transaction revenue in multiple currencies:

transactions

txn_id	amount	currency	txn_date
1	100	USD	2024-01-10
2	200	EUR	2024-01-11
3	5000	JPY	2024-01-12
4	150	EUR	2024-01-20
5	120	USD	2024-01-25

A second table tracks daily FX rates vs USD:

fx_rates

rate_date	currency	usd_rate
2024-01-10	USD	1.00
2024-01-10	EUR	1.10
2024-01-10	JPY	0.007
2024-01-20	EUR	1.15
2024-01-20	JPY	0.0072

📌 FX might be missing on some exact dates
➡️ We must use the most recent rate prior to transaction date

❓Goal:

For each transaction:

1️⃣ Join the latest FX rate up to txn_date
2️⃣ Convert amount → USD revenue
3️⃣ Return:

txn_id

amount

currency

txn_date

usd_rate_used

revenue_in_usd

✅ Expected SQL Answer (PostgreSQL Version)
*/
WITH fx AS (
    SELECT
        t.txn_id,
        t.amount,
        t.currency,
        t.txn_date,
        fr.usd_rate,
        ROW_NUMBER() OVER (
            PARTITION BY t.txn_id
            ORDER BY fr.rate_date DESC
        ) AS rn
    FROM transactions t
    JOIN fx_rates fr
      ON t.currency = fr.currency
     AND fr.rate_date <= t.txn_date
)
SELECT
    txn_id,
    amount,
    currency,
    txn_date,
    usd_rate AS usd_rate_used,
    ROUND(amount * usd_rate, 2) AS revenue_in_usd
FROM fx
WHERE rn = 1
ORDER BY txn_id;