/*
🧠 Challenge: Customers Who Purchased the Same Product More Than Once
🗃️ Table:
Purchases (
  purchase_id INT,
  customer_id INT,
  product_id INT,
  purchase_date DATE,
  quantity INT
)

🎯 Task:

Find customers who purchased the same product more than once (on different dates).

✅ Example Data:
purchase_id	customer_id	product_id	purchase_date	quantity
1	1	101	2023-01-01	2
2	1	101	2023-01-15	1
3	1	102	2023-02-10	3
4	2	101	2023-01-20	1
5	2	103	2023-02-01	2
6	2	103	2023-02-20	1
✅ Expected Output:
customer_id	product_id	times_purchased
1	101	2
2	103	2
✅ MySQL Answer:
*/

SELECT 
    customer_id,
    product_id,
    COUNT(DISTINCT purchase_date) AS times_purchased
FROM Purchases
GROUP BY customer_id, product_id
HAVING COUNT(DISTINCT purchase_date) > 1;