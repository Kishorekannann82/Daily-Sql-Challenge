--Write a sql query to show all products and the number of orders for each product
--Medium Level Question
--Query
select 
p.product_id,p.product_name,
count(o.product_id) as order_count 
from products p 
left join order_items o on p.product_id=o.product_id 
group by p.product_id,p.product_name