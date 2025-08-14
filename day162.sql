/*
🧠 Challenge: Customers Who Ordered in Every Month
🗃️ Table:
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)
/*
🎯 Task:
Find all user_id values for customers who placed at least one order in every month of 2024.
*/
SELECT 
    user_id
FROM Orders
WHERE YEAR(order_date) = 2024
GROUP BY user_id
HAVING COUNT(DISTINCT MONTH(order_date)) = 12;
