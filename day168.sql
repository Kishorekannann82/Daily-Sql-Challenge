/*
🧠 Challenge: Customers Who Purchased in Consecutive Months
🗃️ Table: Purchases
*/
Employees (
  emp_id INT,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary DECIMAL(10,2)
);
/*
Task:

For each department, find the second highest salary and the employee(s) who earn it.
*/
WITH monthly_purchases AS (
    SELECT 
        user_id,
        DATE_FORMAT(purchase_date, '%Y-%m') AS purchase_month
    FROM Purchases
    GROUP BY user_id, DATE_FORMAT(purchase_date, '%Y-%m')
),
with_lag AS (
    SELECT 
        user_id,
        purchase_month,
        LAG(purchase_month) OVER (PARTITION BY user_id ORDER BY purchase_month) AS prev_month
    FROM monthly_purchases
)
SELECT 
    user_id,
    prev_month AS first_month,
    purchase_month AS next_month
FROM with_lag
WHERE TIMESTAMPDIFF(MONTH, prev_month, purchase_month) = 1;
