--Write a query to find the customers who have not placed any orders in the last year
--Medium Level
--Query
select customer_id,customer_name from customers where customer_id not in (select Distinct customer_id from orders
                                                                            where order_date>=date_sub(curdate(),interval 1 year));