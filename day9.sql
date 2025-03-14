--Q7: Calculate the cumulative sales for each store, but only include dates where the daily sales exceeded the store's average daily sales.

--Tables: sales (store_id, sale_amount, sale_date)
--Amazon Interview Questions
--Query
with avg_sales as(
    select store_id,Avg(sales_amount) as avgsales 
    from sales
    group by store_id;
),
filtered_sales as(
    select store_id,sales_amount,sale_date
    from sales s 
    join avg_sales avs on s.store_id=avs.store_id
    where s.sales_amount>avs.sale_amount
)
select store_id,sale_date,sum(sale_amount) over( partition by store_id order by sale_date) as cumulative_sum
from filtered_sales
order by 1,2;