/*
You work at a bank like HDFC. The risk team wants to find accounts whose running balance dropped below zero at any point in their transaction history. Each transaction is either a credit (money in) or debit (money out). Return the account_id, the transaction where it went negative, and the running balance at that point.
Table: transactions
txn_id	account_id	txn_date	type	amount
1	A01	2024-01-01	credit	1000
2	A01	2024-01-05	debit	600
3	A01	2024-01-10	debit	500
4	A01	2024-01-15	credit	200
5	A02	2024-01-02	credit	500
6	A02	2024-01-08	debit	300
7	A02	2024-01-14	debit	100
8	A03	2024-01-03	credit	800
9	A03	2024-01-09	debit	900
10	A03	2024-01-20	credit	400
Expected output
account_id	txn_id	txn_date	running_balance
A01	3	2024-01-10	-100
A03	9	2024-01-09	-100
A01 → 1000 → -600 = 400 → -500 = -100 ❌ went negative on Jan 10
A02 → 500 → -300 = 200 → -100 = 100 → always positive ✅
A03 → 800 → -900 = -100 ❌ went negative on Jan 9
*/
WITH signed_txns AS (
  SELECT
    txn_id,
    account_id,
    txn_date,
    type,
    CASE
      WHEN type = 'credit' THEN  amount
      WHEN type = 'debit'  THEN -amount
    END AS signed_amount
  FROM transactions
),
running AS (
  SELECT
    txn_id,
    account_id,
    txn_date,
    SUM(signed_amount) OVER (
      PARTITION BY account_id
      ORDER BY txn_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance
  FROM signed_txns
)
SELECT
  account_id,
  txn_id,
  txn_date,
  running_balance
FROM running
WHERE running_balance < 0
ORDER BY account_id, txn_date;