/*
Flag accounts with 3 consecutive failed transactions
You're at a fintech company (think PhonePe / Razorpay). The fraud team wants to flag any account that had 3 or more consecutive failed transactions at any point in their history. Return the account_id and the start date of the first failure in that streak.
Table: transactions
txn_id	account_id	txn_date	status
1	A01	2024-01-01	success
2	A01	2024-01-02	failed
3	A01	2024-01-03	failed
4	A01	2024-01-04	failed
5	A01	2024-01-05	success
6	A02	2024-01-01	failed
7	A02	2024-01-02	success
8	A02	2024-01-03	failed
9	A03	2024-01-01	failed
10	A03	2024-01-02	failed
11	A03	2024-01-03	failed
12	A03	2024-01-04	failed
Expected output
account_id	streak_start	consecutive_failures
A01	2024-01-02	3
A03	2024-01-01	4
*/
with numbered as (
    select account_id,status,txn_date,row_number() over(partition by account_id order by txn_date) as rn_all,
    row_number() over(partition by account_id,status order by txn_date) as rn_status
),
streaks as (
    select account_id,status,txn_date,rn_all,rn_status,
    rn_all-rn_status as streak_id
    from numbered
    where status='failed'
)
select account_id,min(txn_date) as streak_start,count(*) as consecutive_failures
from streaks
group by account_id,streak_id
having count(*) >= 3;

--End of the SQl Query;
--Powered by Kishore