/*
🧠 Challenge: Highest Spending Customer per Month
🗃️ Table:
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:

For each month in 2024, find the customer who spent the most in that month.
If there’s a tie, return all top spenders.
*/
WITH MonthlyTotals AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        user_id,
        SUM(total_amount) AS total_spent
    FROM Orders
    WHERE YEAR(order_date) = 2024
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), user_id
),
Ranked AS (
    SELECT 
        month,
        user_id,
        total_spent,
        RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rnk
    FROM MonthlyTotals
)
SELECT 
    month,
    user_id,
    total_spent
FROM Ranked
WHERE rnk = 1;
