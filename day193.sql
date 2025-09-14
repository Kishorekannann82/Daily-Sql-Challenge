/*
🧠 Challenge: Customers Who Ordered in Consecutive Months
🗃️ Table:
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

Find customers who placed orders in at least 2 consecutive months.

✅ Example Data:
order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	1	2023-02-10	150.00
103	1	2023-04-12	300.00
104	2	2023-01-15	400.00
105	2	2023-03-20	500.00
106	3	2023-02-01	600.00
107	3	2023-03-05	250.00
✅ Expected Output:
customer_id	month1	month2
1	2023-01	2023-02
3	2023-02	2023-03
--
*/
--✅ MySQL Answer:
WITH MonthlyOrders AS (
    SELECT DISTINCT 
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month
    FROM Orders
),
WithLag AS (
    SELECT 
        customer_id,
        order_month,
        LAG(order_month) OVER (PARTITION BY customer_id ORDER BY order_month) AS prev_month
    FROM MonthlyOrders
)
SELECT 
    customer_id,
    prev_month AS month1,
    order_month AS month2
FROM WithLag
WHERE prev_month IS NOT NULL
  AND TIMESTAMPDIFF(MONTH, prev_month, order_month) = 1;