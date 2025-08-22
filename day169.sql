/*
🧠 Challenge: Repeat Customers
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  amount DECIMAL(10,2)
);
/*
🎯 Task:

Find all customers who made more than one order and return their first_order_date and second_order_date.
*/
WITH ranked_orders AS (
    SELECT 
        user_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
    FROM Orders
)
SELECT 
    o1.user_id,
    o1.order_date AS first_order_date,
    o2.order_date AS second_order_date
FROM ranked_orders o1
JOIN ranked_orders o2 
    ON o1.user_id = o2.user_id
   AND o1.rn = 1 
   AND o2.rn = 2;
