/*
📌 Challenge 2.0 — Day 32: "Detecting Duplicate Transactions (Near-Duplicate, Not Exact)"

Scenario:
You're a Data Analyst at a payments company. A bug caused some transactions to get double-submitted — not exact duplicate rows (different transaction_id), but the same customer, same amount, within 2 minutes of each other. Risk wants these flagged for manual review before reconciliation.

Table: transactions

Column	Type
transaction_id	INT
customer_id	INT
amount	DECIMAL
transaction_time	TIMESTAMP

Task: Find all pairs of transactions from the same customer, with the same amount, where the time gap between them is 2 minutes or less. Output customer_id, transaction_id_1, transaction_id_2, amount, time_gap_seconds — each pair listed once.
*/
SELECT 
    t1.customer_id,
    t1.transaction_id AS transaction_id_1,
    t2.transaction_id AS transaction_id_2,
    t1.amount,
    EXTRACT(EPOCH FROM (t2.transaction_time - t1.transaction_time)) AS time_gap_seconds
FROM transactions t1
JOIN transactions t2
    ON t1.customer_id = t2.customer_id
    AND t1.amount = t2.amount
    AND t1.transaction_id < t2.transaction_id        -- avoid duplicate pairs + self-pairing
    AND t2.transaction_time >= t1.transaction_time    -- ensure t2 is chronologically after (or equal to) t1
WHERE t2.transaction_time <= t1.transaction_time + INTERVAL '2 minutes'
ORDER BY t1.customer_id, t1.transaction_time;
