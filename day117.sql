/*
🧠 Challenge: Top Spending Users per Month
🗃️ Tables:
*/
Orders (
    order_id INT,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
)

/*
🎯 Your Task:
For each month, find the top 3 users who spent the most (based on total total_amount of their orders in that month). Return:

month (e.g., '2024-05')

user_id

total_spent

rank_in_month
*/
with MonthlySpending as (
    select date_format(order_date,'%Y-%m') as month,
    user_id,
    sum(total_amount) as total_spent
    from Orders
    group by DATE_FORMAT(order_date, '%Y-%m'), user_id
),
Ranking as (
    select user_id,
    month,
    total_spent,
    rank() over(partition by month order by total_spent desc) as rank_in_month
    from MonthlySpending
)
select 
  month,
  user_id,
  total_spent,
  rank_in_month
FROM RankedSpending
WHERE rank_in_month <= 3
ORDER BY month, rank_in_month;