/*
🧠 Challenge: Days Between Consecutive Orders
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

For each user, calculate the number of days between each consecutive order.
*/
SELECT 
    user_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date) AS prev_order_date,
    DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY user_id ORDER BY order_date)) AS days_between
FROM Orders;
