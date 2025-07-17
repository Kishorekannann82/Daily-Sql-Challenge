/*
🧠 Challenge: Top Spending Customer Each Month
🗃️ Tables:
Customers
*/
Customers (
  customer_id INT,
  customer_name VARCHAR(100)
)
Orders
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:
For each month, identify the customer who spent the most (highest total order amount in that month).
If there’s a tie, return any one of them.
*/
WITH MonthlyTotals AS (
  SELECT
    c.customer_id,
    c.customer_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(o.total_amount) AS total_spent
  FROM Orders o
  JOIN Customers c ON o.customer_id = c.customer_id
  GROUP BY c.customer_id, c.customer_name, DATE_FORMAT(o.order_date, '%Y-%m')
),
RankedSpenders AS (
  SELECT *,
    RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rank_in_month
  FROM MonthlyTotals
)
SELECT
  month,
  customer_id,
  customer_name,
  total_spent
FROM RankedSpenders
WHERE rank_in_month = 1
ORDER BY month;
