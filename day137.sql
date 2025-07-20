/*
🧠 Challenge: Customer Order Gaps
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)
/*
🎯 Task:
For each user, find the number of days between each of their consecutive orders. Return the following columns:
user_id
order_id
order_date
days_since_last_order (NULL for the first order)
*/
SELECT 
    user_id,
    order_id,
    order_date,
    DATEDIFF(order_date, LAG(order_date) OVER (
        PARTITION BY user_id ORDER BY order_date
    )) AS days_since_last_order
FROM Orders;
