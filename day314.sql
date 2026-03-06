/*
Running Account Balance
📊 Scenario

You have a transaction table for bank accounts.

transactions
txn_id	account_id	txn_date	amount
1	A1	2024-01-01	100
2	A1	2024-01-03	-30
3	A1	2024-01-05	50
4	A2	2024-01-02	200
5	A2	2024-01-04	-100
6	A2	2024-01-06	70

Positive amount → deposit

Negative amount → withdrawal

🎯 Goal

Calculate running balance for each account after every transaction.

Return:

account_id

txn_date

amount

running_balance

🧠 Expected Output
account_id	txn_date	amount	running_balance
A1	2024-01-01	100	100
A1	2024-01-03	-30	70
A1	2024-01-05	50	120
A2	2024-01-02	200	200
A2	2024-01-04	-100	100
A2	2024-01-06	70	170
✅ SQL Solution
*/
SELECT
    account_id,
    txn_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY account_id
        ORDER BY txn_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance
FROM transactions
ORDER BY account_id, txn_date;