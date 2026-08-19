/*
Day 12: "Detecting Fraudulent Transaction Patterns"

Scenario:
You're a Data Analyst at a fintech company. The fraud team flags a pattern: 3 or more transactions from the same card within a 10-minute window, where the total amount exceeds $1000. This is a common card-testing/fraud signature.

Table: transactions

Column	Type
transaction_id	INT
card_id	INT
transaction_time	TIMESTAMP
amount	DECIMAL

Task: For each card, find every transaction that is the 3rd (or later) transaction within a rolling 10-minute window from itself looking backward, where the sum of that window exceeds $1000. Output card_id, transaction_id, transaction_time, amount, window_sum, txn_count_in_window.
*/
WITH windowed AS (
    SELECT 
        t1.card_id,
        t1.transaction_id,
        t1.transaction_time,
        t1.amount,
        COUNT(*) OVER (
            PARTITION BY t1.card_id 
            ORDER BY t1.transaction_time 
            RANGE BETWEEN INTERVAL '10' MINUTE PRECEDING AND CURRENT ROW
        ) AS txn_count_in_window,
        SUM(t1.amount) OVER (
            PARTITION BY t1.card_id 
            ORDER BY t1.transaction_time 
            RANGE BETWEEN INTERVAL '10' MINUTE PRECEDING AND CURRENT ROW
        ) AS window_sum
    FROM transactions t1
)
SELECT 
    card_id,
    transaction_id,
    transaction_time,
    amount,
    window_sum,
    txn_count_in_window
FROM windowed
WHERE txn_count_in_window >= 3
  AND window_sum > 1000
ORDER BY card_id, transaction_time;
