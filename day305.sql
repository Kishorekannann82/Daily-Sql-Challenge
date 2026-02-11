/*
etect High-Velocity Transaction Fraud
Scenario

You monitor card transactions.
A transaction is suspicious if:

More than 3 transactions occur within 10 minutes for the same card.

card_transactions
txn_id	card_id	txn_time	amount
1	C1	2024-01-01 10:00	100
2	C1	2024-01-01 10:02	150
3	C1	2024-01-01 10:05	200
4	C1	2024-01-01 10:07	120
5	C1	2024-01-01 11:00	300
6	C2	2024-01-01 09:00	50
7	C2	2024-01-01 09:20	70

📌 Rule

Rolling window: last 10 minutes

If count > 3 → flag as SUSPICIOUS

❓ Goal

Return:

txn_id

card_id

txn_time

txns_last_10_min

fraud_flag

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH rolling AS (
    SELECT
        t1.txn_id,
        t1.card_id,
        t1.txn_time,
        (
            SELECT COUNT(*)
            FROM card_transactions t2
            WHERE t2.card_id = t1.card_id
              AND t2.txn_time BETWEEN
                  t1.txn_time - INTERVAL 10 MINUTE
                  AND t1.txn_time
        ) AS txns_last_10_min
    FROM card_transactions t1
)
SELECT
    txn_id,
    card_id,
    txn_time,
    txns_last_10_min,
    CASE
        WHEN txns_last_10_min > 3 THEN 'SUSPICIOUS'
        ELSE 'NORMAL'
    END AS fraud_flag
FROM rolling
ORDER BY card_id, txn_time;