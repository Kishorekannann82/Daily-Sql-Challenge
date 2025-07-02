/*
🧠 Challenge: Running Total of Daily Sales
🗃️ Table: Sales
*/
Sales (
    sale_id INT,
    sale_date DATE,
    amount DECIMAL(10,2)
)
/*
🎯 Your Task:
For each day, compute:

Total sales on that day (daily_total)

The running total of sales up to that day (running_total)
*/
with Daily as (
    select sale_id,
    sum(amount) as daily_total
    from Sales
    group bu sale_id
)
select sale_id,
daily_total,
sum(amount) over(partition by sale_id order y sale_date) as running_total
from Daily;