/*
🧠 Challenge: Customers Who Placed Orders on Consecutive Days
🗃️ Table:
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

Find customers who have placed at least two orders on consecutive days.

✅ Example Data:
order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	1	2023-01-06	150.00
103	1	2023-01-08	300.00
104	2	2023-02-10	400.00
105	2	2023-02-12	500.00
106	3	2023-03-01	600.00
107	3	2023-03-02	250.00
✅ Expected Output:
customer_id
1
3

(Customer 1 → orders on 2023-01-05 & 2023-01-06; Customer 3 → orders on 2023-03-01 & 2023-03-02)

✅ MySQL Answer (Using LAG()):
*/

WITH OrderDiff AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
)
SELECT DISTINCT customer_id
FROM OrderDiff
WHERE DATEDIFF(order_date, prev_date) = 1;
