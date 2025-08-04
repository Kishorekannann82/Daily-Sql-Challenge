/*
🧠 Challenge: Top Spending Customers Each Month
🗃️ Tables
*/
Customers (
  customer_id INT,
  customer_name VARCHAR(255)
)

Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)

/*
🎯 Task:
For each month, find the customer(s) who spent the most total amount on orders.

✅ Output columns:

month (formatted as YYYY-MM)

customer_id

customer_name

total_spent

If there are ties, return all top customers for that month.
*/
WITH MonthlySpending AS (
  SELECT 
    c.customer_id,
    c.customer_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(o.total_amount) AS total_spent
  FROM Orders o
  JOIN Customers c ON o.customer_id = c.customer_id
  GROUP BY c.customer_id, c.customer_name, DATE_FORMAT(o.order_date, '%Y-%m')
),
RankedSpending AS (
  SELECT 
    *,
    RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rnk
  FROM MonthlySpending
)
SELECT 
  month,
  customer_id,
  customer_name,
  total_spent
FROM RankedSpending
WHERE rnk = 1
ORDER BY month;
