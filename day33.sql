--Write a sql query to find out the how many products were sold in each category
--Medium Level Question
--query
select c.category_name,sum(oi.quantity) as total_products
from categories
join products p on c.category_id=p.category_id
join order_items oi 
on p.product_id=oi.product_id
group bu c.category_name