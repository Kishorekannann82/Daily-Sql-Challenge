--Write a query to list the customers who have the placed the most orders
--Medium Level Interview Question
--Query
select customer_id,count(order_id) as count_orders
from orders
group by customer_id
order by 2
limit 1