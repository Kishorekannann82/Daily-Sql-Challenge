/*
🧠 Challenge: Customers Who Never Placed an Order
🗃️ Tables:
Customers (
  customer_id INT,
  customer_name VARCHAR(50)
)

Orders (
  order_id INT,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
)

🎯 Task:

Find all customers who have never placed an order.

✅ Example Data:

Customers

customer_id	customer_name
1	Alice
2	Bob
3	Charlie
4	Diana

Orders

order_id	customer_id	order_date	total_amount
101	1	2023-01-05	200.00
102	2	2023-01-20	400.00
✅ Expected Output:


customer_id	customer_name
3	Charlie
4	Diana
✅ MySQL Answer (Using LEFT JOIN):
*/
SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

