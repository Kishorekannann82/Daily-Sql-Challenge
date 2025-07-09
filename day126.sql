/*
🧠 Challenge: Rank Users by Total Spending Percentiles
🗃️ Table: Purchases
*/
Purchases (
    purchase_id INT,
    user_id INT,
    amount DECIMAL(10, 2),
    purchase_date DATE
)
/*
🎯 Your Task:
For each user:

Calculate the total amount spent.

Assign them into percentile ranks based on their total spending:

Top 25% → 4th percentile group

Next 25% → 3rd percentile group

Next 25% → 2nd percentile group

Bottom 25% → 1st percentile group

*/
with UserSpending as (
    select
    user_id,
    sum(amount) as total_spending 
    from Purchases
    group by user_id
)
select 
user_id,
total_spending,
NTILE(4) over(order by total_spending) as percentile_group 
from UserSpending;