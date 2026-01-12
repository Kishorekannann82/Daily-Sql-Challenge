/*
Join Transactions to the Correct Historical Price (As-Of Join)
Scenario

You record transactions, but prices change over time.
Each transaction must be valued using the most recent price at or before the transaction time.

transactions
txn_id	product_id	txn_time	quantity
1	A	2024-01-01 10:00	5
2	A	2024-01-02 09:00	3
3	B	2024-01-01 12:00	2
4	B	2024-01-03 15:00	4
price_history
product_id	price	effective_time
A	10	2024-01-01 00:00
A	12	2024-01-02 00:00
B	20	2024-01-01 00:00
B	18	2024-01-03 00:00

📌 Rule
For each transaction, use:

price where effective_time <= txn_time
AND it is the LATEST such price

❓ Goal

Return:

txn_id

product_id

txn_time

quantity

price_used

transaction_value

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH priced AS (
    SELECT
        t.txn_id,
        t.product_id,
        t.txn_time,
        t.quantity,
        p.price,
        ROW_NUMBER() OVER (
            PARTITION BY t.txn_id
            ORDER BY p.effective_time DESC
        ) AS rn
    FROM transactions t
    JOIN price_history p
      ON t.product_id = p.product_id
     AND p.effective_time <= t.txn_time
)
SELECT
    txn_id,
    product_id,
    txn_time,
    quantity,
    price AS price_used,
    quantity * price AS transaction_value
FROM priced
WHERE rn = 1
ORDER BY txn_id;