--Amazon Interview question
--Find customers who placed more than 50% of their orders in their last month
--Tables:sales(customer_id,order_id,order_date)
--query
with order_sales as(
    select customer_id,count(*) as total_sales,
    sum(case when order_date>=dateadd(month,-1,current_date)then 1 else 0 end) as last_month_orders
    from orders
    group by customer_id

)
select customer_id,
from order_sales
where last_month_orders>0.5*total_sales;