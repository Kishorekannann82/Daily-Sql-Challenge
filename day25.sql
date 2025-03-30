--write a query to find all products that were ordered by more than one customer.
--Medium Level Question
--Query
select product_id,product_name from orders_items
join product on o.product_id=p.product_id
group by product_id,product_name
Having count(Distinct customer_id)>1;