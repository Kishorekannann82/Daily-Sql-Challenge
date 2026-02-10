/*
Reconcile Ledger Balances with Transaction Records
Scenario

You maintain:

a transaction log (source of truth for money movement)

a daily ledger snapshot (what the system thinks the balance is)

Your job is to find mismatches between the two.

transactions
txn_id	account_id	txn_date	amount
1	A1	2024-01-01	+100
2	A1	2024-01-02	-30
3	A1	2024-01-03	+20
4	A2	2024-01-01	+200
5	A2	2024-01-03	-50
ledger_daily
account_id	ledger_date	ledger_balance
A1	2024-01-01	100
A1	2024-01-02	70
A1	2024-01-03	90
A2	2024-01-01	200
A2	2024-01-03	160

📌 Rule

ledger_balance
=
SUM(transactions.amount up to that date)

❓ Goal

For each account & date:

Compute the expected balance

Compare with ledger balance

Flag mismatches

Return:

account_id

ledger_date

expected_balance

ledger_balance

difference

reconciliation_status

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH running_txn AS (
    SELECT
        account_id,
        txn_date,
        SUM(amount) OVER (
            PARTITION BY account_id
            ORDER BY txn_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_balance
    FROM transactions
),
ledger_expected AS (
    SELECT
        l.account_id,
        l.ledger_date,
        l.ledger_balance,
        MAX(r.running_balance) AS expected_balance
    FROM ledger_daily l
    LEFT JOIN running_txn r
      ON l.account_id = r.account_id
     AND r.txn_date <= l.ledger_date
    GROUP BY
        l.account_id,
        l.ledger_date,
        l.ledger_balance
)
SELECT
    account_id,
    ledger_date,
    expected_balance,
    ledger_balance,
    ledger_balance - expected_balance AS difference,
    CASE
        WHEN ledger_balance = expected_balance THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS reconciliation_status
FROM ledger_expected
ORDER BY account_id, ledger_date;