/*
🧠 Challenge: Find Second Highest Spending User per Month
🗃️ Tables:
*/
Users (
  user_id INT,
  user_name VARCHAR
)

Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  total_amount DECIMAL(10, 2)
)
/*
🎯 Task:
For each month, find the user who had the second highest total spending in that month.
*/
| month   | user\_id | user\_name | total\_spent |
| ------- | -------- | ---------- | ------------ |
| 2024-01 | 102      | Alice      | 850.00       |
| 2024-02 | 201      | Bob        | 720.00       |
| ...     | ...      | ...        | ...          |
WITH MonthlySpending AS (
  SELECT
    user_id,
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_spent
  FROM Orders
  GROUP BY user_id, DATE_FORMAT(order_date, '%Y-%m')
),
RankedSpending AS (
  SELECT 
    ms.*,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rank
  FROM MonthlySpending ms
)
SELECT 
  rs.month,
  rs.user_id,
  u.user_name,
  rs.total_spent
FROM RankedSpending rs
JOIN Users u ON rs.user_id = u.user_id
WHERE rs.rank = 2;

