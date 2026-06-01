/*
Find users who transacted within 7 days of signup
You work at a fintech company like PhonePe or Google Pay. The growth team tracks activation rate — users who make their first transaction within 7 days of signing up are considered "activated". Find all activated users. Return user_id, signup_date, first_txn_date, and days_to_activate.
Table: users
user_id	name	signup_date
U01	Anil	2024-01-01
U02	Bina	2024-01-03
U03	Charan	2024-01-05
U04	Devi	2024-01-07
U05	Elan	2024-01-10
Table: transactions
txn_id	user_id	txn_date	amount
1	U01	2024-01-04	500
2	U01	2024-01-09	300
3	U02	2024-01-15	800
4	U03	2024-01-07	200
5	U03	2024-01-12	150
6	U04	2024-01-08	1000
7	U05	2024-01-20	600
Expected output
user_id	signup_date	first_txn_date	days_to_activate
U01	2024-01-01	2024-01-04	3
U03	2024-01-05	2024-01-07	2
U04	2024-01-07	2024-01-08	1
U01 Anil → signup Jan 1, first txn Jan 4 → 3 days ✅ activated
U02 Bina → signup Jan 3, first txn Jan 15 → 12 days ❌ too late
U03 Charan → signup Jan 5, first txn Jan 7 → 2 days ✅ activated
U04 Devi → signup Jan 7, first txn Jan 8 → 1 day ✅ activated
U05 Elan → signup Jan 10, first txn Jan 20 → 10 days ❌ too late
*/
with first_txn as(
    select txn_id,
    min(txn_date) as first_txn
    from transactions
    group by txn_id
)
select u.user_id,
u.signup_date as signup_date,
f.first_txn as first_txn_date,
first_txn-u.signup_date as days_to_activate
from users u
JOIN first_txn f
  ON u.user_id = f.user_id
WHERE
  f.first_txn_date - u.signup_date BETWEEN 0 AND 7
ORDER BY days_to_activate;