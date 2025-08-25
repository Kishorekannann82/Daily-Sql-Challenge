/*
🧠 Challenge: First and Last Order Per User
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  amount DECIMAL(10,2)
);
/*🎯 Task:

For each user, find their first order date and last order date.
*/
SELECT user_id,
         MIN(order_date) AS first_order_date,
         MAX(order_date) AS last_order_date
         from Orders
         GROUP BY user_id;