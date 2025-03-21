--Rank Sales by their monthly sales performance
--table(store_id,sale_amount,sale_date)
--Amazon Interview Question
--Query
with monthly_sales as(
    select store_id,datetrunc('month',sales_date) as sale_month
    sum(sale_amount) as total_sales
    group by store_id,datetrunc('month',sale_date)
)
select store_id,sales_month,total_sales,rank() over(partition by sale_month order by total_sales desc) as rank
from monthly_sales