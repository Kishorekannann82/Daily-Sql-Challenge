--Write a Sql Query to find the total sales for each month
--Medium LEVEL
--Query
select year(order_date) as year,month(order) as month,sum(total_amount) as total sales
from sales 
group by year(order_date),month(order_date) 
order by year,month