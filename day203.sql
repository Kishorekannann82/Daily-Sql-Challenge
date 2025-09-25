/*
🧠 Challenge: Customers Who Bought All Products
🗃️ Tables:
Customers (
  customer_id INT,
  customer_name VARCHAR(50)
)

Products (
  product_id INT,
  product_name VARCHAR(50)
)

Purchases (
  purchase_id INT,
  customer_id INT,
  product_id INT,
  purchase_date DATE
)

🎯 Task:

Find customers who purchased every product available in the Products table.

✅ Example Data:

Products

product_id	product_name
101	Laptop
102	Phone
103	Tablet

Purchases

purchase_id	customer_id	product_id	purchase_date
1	1	101	2023-01-01
2	1	102	2023-01-10
3	1	103	2023-01-15
4	2	101	2023-01-20
5	2	102	2023-01-25
6	3	101	2023-02-01
7	3	103	2023-02-05
✅ Expected Output:
customer_id	customer_name
1	Alice

(Only Alice bought all products: Laptop, Phone, and Tablet)

✅ MySQL Answer:
*/

SELECT c.customer_id, c.customer_name
FROM Customers c
JOIN Purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM Products);