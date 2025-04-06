--Write a sql query to find the ordrs that were shipped on the same day that they were placed
--Medium Level Question
--Query
select 
order_id,
order_date,ship_date
from orders 
where order_date=ship_date;