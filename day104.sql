/*
🧠 Challenge: Returning Customers by Month
🗃️ Table: Orders
*/
Orders (
    order_id INT,
    user_id INT,
    order_date DATE
)
/*
🎯 Your Task:
For each month, count the number of returning customers — those who placed at least one order in any prior month, 
and placed another order in the current month.
*/
WITH OrdersWithMonth AS (
  SELECT 
    user_id,
    DATE_FORMAT(order_date, '%Y-%m') AS order_month
  FROM Orders
),
FirstOrders AS (
  SELECT 
    user_id,
    MIN(order_month) AS first_month
  FROM OrdersWithMonth
  GROUP BY user_id
),
ReturningOrders AS (
  SELECT 
    o.user_id,
    o.order_month
  FROM OrdersWithMonth o
  JOIN FirstOrders f 
    ON o.user_id = f.user_id
  WHERE o.order_month > f.first_month
)
SELECT 
  order_month AS month,
  COUNT(DISTINCT user_id) AS returning_customers
FROM ReturningOrders
GROUP BY order_month
ORDER BY order_month;

