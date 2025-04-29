/*
🧠 Challenge: Calculate Percentile Rank of Each User Based on Their Total Spend
🗃️ Table: Transactions
*/
Transactions (
    user_id INT,
    amount DECIMAL,
    transaction_date DATE
)
/*
🎯 Your Task:
Calculate the percentile rank of each user based on their total amount spent.
Percentile rank is the percentage of users who spent less than or equal to that user.
*/
--Query
with TotalSpend as(
    select user_id,
    sum(amount) as total_spend
    from Transactions
    group by user_id
),
Ranked as(
    select user_id,total_spend,
    percent_rank() over(order by total_spend)*100 as percentile_rank
    from TotalSpend
)
select user_id,
total_spend,
round(percentile_rank,2) as Percent 
from Ranked
group by total_spend;

