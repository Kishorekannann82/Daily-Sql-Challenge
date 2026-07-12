/*
Flag transactions 3x above the user's own average
You work at Razorpay's fraud team. A transaction is suspicious if its amount is more than 3 times the user's average transaction amount (excluding the transaction itself — unbias the average). Return user_id, txn_id, amount, user_avg (rounded to 1 decimal), and times_above_avg (rounded to 1 decimal).
Table: transactions
txn_id	user_id	amount	txn_date
T01	U01	200	2024-05-01
T02	U01	250	2024-05-03
T03	U01	180	2024-05-07
T04	U01	900	2024-05-10
T05	U02	1000	2024-05-02
T06	U02	1200	2024-05-05
T07	U02	950	2024-05-08
T08	U02	5000	2024-05-12
T09	U03	300	2024-05-01
T10	U03	320	2024-05-06
T11	U03	280	2024-05-09
Expected output
user_id	txn_id	amount	user_avg_excl	times_above_avg
U01	T04	900	210.0	4.3
U02	T08	5000	1050.0	4.8
U01 T04 (900): avg excl T04 = (200+250+180)/3 = 210.0 → 900/210 = 4.3x ✅ flagged
U02 T08 (5000): avg excl T08 = (1000+1200+950)/3 = 1050.0 → 5000/1050 = 4.8x ✅ flagged
U03: max txn=320, avg excl = (300+320)/2 or (300+280)/2 ≈ 300 → 320/300 = 1.07x ❌ safe
|*/
WITH excl_avg AS (
  -- For each transaction, compute avg of ALL OTHER transactions by same user
  SELECT
    t1.txn_id,
    t1.user_id,
    t1.amount,
    ROUND(AVG(t2.amount), 1) AS user_avg_excl
  FROM transactions t1
  JOIN transactions t2
    ON  t1.user_id = t2.user_id
    AND t1.txn_id != t2.txn_id   -- exclude the current transaction
  GROUP BY t1.txn_id, t1.user_id, t1.amount
)
SELECT
  user_id,
  txn_id,
  amount,
  user_avg_excl,
  ROUND(amount * 1.0 / NULLIF(user_avg_excl, 0), 1) AS times_above_avg
FROM excl_avg
WHERE amount > user_avg_excl * 3
ORDER BY times_above_avg DESC;
