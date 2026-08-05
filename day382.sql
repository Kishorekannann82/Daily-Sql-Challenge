/*
Find accounts with no transactions in the last 12 months
You work at a bank. RBI mandates that accounts with no transactions for 12+ months must be flagged as dormant. Find all dormant accounts. Return account_id, account_holder, account_type, last_txn_date, days_since_last_txn, and balance. Assume today is 2024-07-01.
Table: accounts
account_id	account_holder	account_type	balance
A001	Ravi Kumar	Savings	45000
A002	Priya Nair	Current	120000
A003	Suresh Das	Savings	8500
A004	Meena Raj	Savings	32000
A005	Kiran Babu	Current	5000
Table: transactions
txn_id	account_id	txn_date	amount
T01	A001	2024-05-15	5000
T02	A001	2024-06-01	2000
T03	A002	2023-05-20	15000
T04	A002	2023-06-10	8000
T05	A003	2023-03-01	1000
T06	A004	2024-01-15	3000
T07	A004	2024-03-20	1500
Expected output
account_id	account_holder	account_type	last_txn_date	days_since_txn	balance
A002	Priya Nair	Current	2023-06-10	386	120000
A003	Suresh Das	Savings	2023-03-01	487	8500
A005	Kiran Babu	Current	NULL	NULL	5000
A001 Ravi → last txn Jun1 2024, days since = 30 → active ❌
A002 Priya → last txn Jun10 2023, days since = 386 → dormant ✅
A003 Suresh → last txn Mar1 2023, days since = 487 → dormant ✅
A004 Meena → last txn Mar20 2024, days since = 103 → active ❌
A005 Kiran → NO transactions ever → dormant ✅ (NULL last txn)
*/
WITH last_txn AS (
  SELECT
    account_id,
    MAX(txn_date) AS last_txn_date
  FROM transactions
  GROUP BY account_id
)
SELECT
  a.account_id,
  a.account_holder,
  a.account_type,
  lt.last_txn_date,
  CASE
    WHEN lt.last_txn_date IS NOT NULL
    THEN (DATE '2024-07-01' - lt.last_txn_date)
    ELSE NULL
  END                  AS days_since_last_txn,
  a.balance
FROM accounts a
LEFT JOIN last_txn lt
  ON a.account_id = lt.account_id
WHERE
  lt.last_txn_date < DATE '2023-07-01'
  OR lt.last_txn_date IS NULL
ORDER BY days_since_last_txn DESC NULLS LAST;
