/*
🧠 Challenge: Highest Spending Customer per Month
🗃️ Table: Orders
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  amount DECIMAL(10,2)
);
/*
🎯 Task:

For each month, find the customer who spent the most total amount.
*/
WITH monthly_spending AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        user_id,
        SUM(amount) AS total_spent
    FROM Orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), user_id
),
ranked AS (
    SELECT 
        month,
        user_id,
        total_spent,
        RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rn
    FROM monthly_spending
)
SELECT 
    month,
    user_id,
    total_spent
FROM ranked
WHERE rn = 1;
