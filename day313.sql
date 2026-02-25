/*
Monthly Revenue Growth %
📊 Scenario

You track monthly revenue.

monthly_revenue
month	revenue
2024-01	10000
2024-02	12000
2024-03	9000
2024-04	15000
2024-05	18000
🎯 Goal

For each month (except the first), calculate:

previous_month_revenue

revenue_growth_amount

revenue_growth_percentage

🧠 Expected Output
month	revenue	prev_revenue	growth_amt	growth_%
2024-02	12000	10000	2000	20.00
2024-03	9000	12000	-3000	-25.00
2024-04	15000	9000	6000	66.67
2024-05	18000	15000	3000	20.00
*/
select month,revenue,
lag(revenue) over (order by month) as prev_revenue,
revenue-prev_revenue as growth_amt,
round((revenue-prev_revenue)/prev_revenue*100,2) as growth_%
from monthly_revenue
where month>'2024-01';
