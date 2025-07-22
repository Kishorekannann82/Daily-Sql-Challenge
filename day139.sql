/*
🧠 Challenge: Users with Orders Every Month
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)

/*
🎯 Task:
Find all users who placed at least one order in every month of the year 2024.

Return:

user_id

*/
SELECT user_id
FROM Orders
WHERE YEAR(order_date) = 2024
GROUP BY user_id
HAVING COUNT(DISTINCT MONTH(order_date)) = 12;
