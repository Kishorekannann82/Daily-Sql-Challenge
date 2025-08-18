/*
🧠 Challenge: Customers Who Purchased Every Product
🗃️ Tables:
*/
Customers (
  customer_id INT,
  customer_name VARCHAR(100)
);

Purchases (
  purchase_id INT,
  customer_id INT,
  product_id INT,
  purchase_date DATE
);

Products (
  product_id INT,
  product_name VARCHAR(100)
);
/*
🎯 Task:

Find all customers who have purchased every product at least once.
*/
SELECT c.customer_id, c.customer_name
FROM Customers c
JOIN Purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.product_id) = (SELECT COUNT(*) FROM Products);
