/*
🧠 Challenge: Users Who Ordered the Same Product More Than Once
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  product_id INT,
  order_date DATE
)
/*
🎯 Task:
Find all users who have ordered the same product more than once.

Return:

user_id

product_id

order_count (how many times the user ordered that product)


*/
SELECT 
  user_id,
  product_id,
  COUNT(*) AS order_count
FROM Orders
GROUP BY user_id, product_id
HAVING COUNT(*) > 1;
