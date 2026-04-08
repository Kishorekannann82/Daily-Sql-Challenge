/*
You're a data analyst at a Swiggy-like food delivery app. A user is considered churned if they had a gap of more than 30 days between two consecutive orders. Find all users who churned at least once but then came back and ordered again. Return their user_id and the gap in days when they churned.
Table: orders
order_id	user_id	order_date
1	U01	2024-01-01
2	U01	2024-01-15
3	U01	2024-03-20
4	U01	2024-03-25
5	U02	2024-02-01
6	U02	2024-02-10
7	U03	2024-01-10
8	U03	2024-04-01
Expected output
user_id	churn_gap_days	churned_on	came_back_on
U01	64	2024-01-15	2024-03-20
U03	82	2024-01-10	2024-04-01
U01 → gap between Jan 15 → Mar 20 is 64 days (churned, but came back ✅)
U02 → all orders within 30 days, never churned → excluded ❌
U03 → gap of 82 days, came back → included ✅
Note: U03 has no order after Apr 1 in this dataset, but the churn+return already happened between the two orders.
*/
with ordered_date as (
    select user id,order_date,lag(order_date) over(partition by user_id order by order date) as next_order_date,
    order_date-lag(order_date) over(partition by user_id order by order_date) as gap_days
    from orders

)
select user_id,gap_days,next_order_date as churned_on,order_date as came_back_on
from ordered_date
where gap_days > 30;
--End of the SQl Query;
--Powered by Kishore
