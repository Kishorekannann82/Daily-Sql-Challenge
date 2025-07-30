/*
🧠 Challenge: Repeat Customers
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)
/*
🎯 Task:
Find all users who made purchases in at least 2 different months.

Return:

user_id

number_of_months (how many distinct months they ordered in)

*/
SELECT 
  user_id,
  COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) AS number_of_months
FROM Orders
GROUP BY user_id
HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 2;
