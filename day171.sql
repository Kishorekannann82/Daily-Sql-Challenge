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

Find all users who placed more than one order (repeat customers) and their total number of orders.
*/
SELECT user_id, COUNT(order_id) AS total_orders 
FROM Orders
GROUP BY user_id
having COUNT(order_id) > 1;