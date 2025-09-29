/*
🧠 Challenge: Highest Spending Customer Per Month
🗃️ Table:
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

For each month, find the customer who spent the most.

✅ Example Data:
order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	2	2023-01-10	500.00
103	3	2023-01-20	300.00
104	1	2023-02-05	700.00
105	2	2023-02-12	600.00
106	3	2023-02-15	100.00
✅ Expected Output:
month	customer_id	total_spent
2023-01	2	500.00
2023-02	1	700.00
✅ MySQL Answer (Using RANK()):
*/
WITH MonthlySpend AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        customer_id,
        SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), customer_id
),
Ranked AS (
    SELECT 
        month,
        customer_id,
        total_spent,
        RANK() OVER (PARTITION BY month ORDER BY total_spent DESC) AS rnk
    FROM MonthlySpend
)
SELECT month, customer_id, total_spent
FROM Ranked
WHERE rnk = 1;