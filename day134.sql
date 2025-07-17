/*
🧠 Challenge: Users with Increasing Order Amounts
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:
Find all users who placed at least three consecutive orders where each order's total_amount is strictly greater than the previous one.
*/
WITH Ordered AS (
  SELECT
    user_id,
    order_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn
  FROM Orders
),
WithDiffs AS (
  SELECT
    o1.user_id,
    o1.rn AS rn1,
    o1.total_amount AS amt1,
    o2.total_amount AS amt2,
    o3.total_amount AS amt3
  FROM Ordered o1
  JOIN Ordered o2 ON o1.user_id = o2.user_id AND o2.rn = o1.rn + 1
  JOIN Ordered o3 ON o1.user_id = o3.user_id AND o3.rn = o1.rn + 2
)
SELECT DISTINCT user_id
FROM WithDiffs
WHERE amt1 < amt2 AND amt2 < amt3;
