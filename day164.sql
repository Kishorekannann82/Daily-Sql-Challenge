/*
🧠 Challenge: Users Who Never Purchased
🗃️ Tables:
*/
Users (
  user_id INT,
  user_name VARCHAR(100)
);

Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
);
/*
🎯 Task:

Find all users who never placed any orders.
*/
SELECT u.user_id, u.user_name
FROM Users u
LEFT JOIN Orders o 
    ON u.user_id = o.user_id
WHERE o.user_id IS NULL;
