/*
🧠 Challenge: Users Who Ordered Every Month in 2024
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)
/*
🎯 Task:
Find users who have at least one order in every month of the year 2024.
*/
WITH MonthlyOrders AS (
  SELECT 
    user_id,
    MONTH(order_date) AS order_month
  FROM Orders
  WHERE YEAR(order_date) = 2024
  GROUP BY user_id, MONTH(order_date)
),
UserMonthCount AS (
  SELECT 
    user_id,
    COUNT(DISTINCT order_month) AS month_count
  FROM MonthlyOrders
  GROUP BY user_id
)
SELECT user_id
FROM UserMonthCount
WHERE month_count = 12;
