/*
🧠 Challenge: Highest Spending Customer Per Month
🗃️ Table:
*/
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)
/*
🎯 Task:

For each month, find the customer who spent the most (highest total order value).
*/
WITH MonthlySpending AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month,
        SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
RankedSpending AS (
    SELECT 
        customer_id,
        order_month,
        total_spent,
        RANK() OVER (PARTITION BY order_month ORDER BY total_spent DESC) AS spending_rank
    FROM MonthlySpending
)
SELECT 
    customer_id,
    order_month,
    total_spent
FROM RankedSpending
WHERE spending_rank = 1
ORDER BY order_month, customer_id;
