--Q9: Identify products that have been sold but have no record in the products table and also calculate how many times each missing product has been sold.

--Tables: sales (product_id), products (product_id)
--Amazon Interview Question
--Query
select s.product_id,count(*) as times_sold 
from sales s 
join products p 
on s.product_id=p.product_id 
where p.product_id is null
group by s.product_id 
order by times_sold desc;