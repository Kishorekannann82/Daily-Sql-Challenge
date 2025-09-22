/*
🧠 Challenge: Average Order Value (AOV) Per Customer
🗃️ Tables:
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

Find the average order value per customer.
(Average order value = total spend / number of orders)

✅ Example Data:
order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	1	2023-01-15	150.00
103	2	2023-02-10	400.00
104	2	2023-02-15	600.00
105	3	2023-03-01	500.00
✅ Expected Output:
customer_id	avg_order_value
1	175.00
2	500.00
3	500.00
✅ MySQL Answer:
*/

SELECT 
    customer_id,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM Orders
GROUP BY customer_id;