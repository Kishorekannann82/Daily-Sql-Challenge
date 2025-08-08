/*
🧠 Challenge: Identify Repeat Customers
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)
/*
🎯 Task:
Find users who have placed more than one order.
For each of these users, return:

user_id

total_orders
*/
SELECT
  user_id,
  COUNT(*) AS total_orders
FROM Orders
GROUP BY user_id
HAVING COUNT(*) > 1;
