/*
🧠 Challenge: Repeat Customers vs. One-Time Customers
🗃️ Table:
Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

Classify customers into:

Repeat Customers → placed more than 1 order

One-Time Customers → placed only 1 order

✅ Example Data:
order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	1	2023-02-10	150.00
103	2	2023-01-20	400.00
104	3	2023-02-01	500.00
105	3	2023-02-15	600.00
*/
✅ Expected Output:
customer_id	customer_type           

1	Repeat Customers
2	One-Time Customers

3	Repeat Customers
(Only customer 2 placed a single order, while customers 1 and 3 placed multiple orders)
✅ MySQL Answer:
*/
SELECT customer_id,
       CASE 
           WHEN COUNT(order_id) > 1 THEN 'Repeat Customers'
           ELSE 'One-Time Customers'
       END AS customer_type
FROM Orders
GROUP BY customer_id;
