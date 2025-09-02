/*
🧠 Challenge: Customers Who Never Ordered
🗃️ Tables:
*/
Users (
  user_id INT,
  user_name VARCHAR(50)
)

Orders (
  order_id INT,
  user_id INT,
  order_date DATE
)

/*
🎯 Task:

Find all users who have never placed an order.
*/
SELECT 
    u.user_id,
    u.user_name
FROM Users u
LEFT JOIN Orders o 
    ON u.user_id = o.user_id
WHERE o.user_id IS NULL;
