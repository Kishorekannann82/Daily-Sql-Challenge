/*
🧠 Challenge: Highest Spending User Each Month
🗃️ Tables:
*/
Users (
  user_id INT,
  user_name TEXT
)

Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:
For each month in 2024, find the user who spent the most (total_amount).
If there’s a tie, return any one of the top spenders for that month.
*/
WITH MonthlySpending AS (
  SELECT 
    user_id,
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_spent
  FROM Orders
  WHERE YEAR(order_date) = 2024
  GROUP BY user_id, month
),
RankedSpenders AS (
  SELECT *,
         RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rank
  FROM MonthlySpending
)
SELECT month, user_id, total_spent
FROM RankedSpenders
WHERE rank = 1;
