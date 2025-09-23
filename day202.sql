/*
🧠 Challenge: Most Frequently Purchased Product Overall
🗃️ Table:
Purchases (
  purchase_id INT,
  customer_id INT,
  product_id INT,
  purchase_date DATE,
  quantity INT
)

🎯 Task:

Find the most frequently purchased product overall (by number of purchases, not quantity).
If there are multiple with the same highest frequency, return them all.

✅ Example Data:
purchase_id	customer_id	product_id	purchase_date	quantity
1	1	101	2023-01-01	2
2	1	101	2023-01-15	1
3	2	102	2023-02-10	3
4	3	101	2023-02-20	1
5	2	103	2023-03-05	2
6	3	102	2023-03-08	2
✅ Expected Output:
product_id	purchase_count
101	3
102	2

(Here product 101 is the most purchased overall)

✅ MySQL Answer:
*/

WITH ProductCounts AS (
    SELECT 
        product_id,
        COUNT(*) AS purchase_count
    FROM Purchases
    GROUP BY product_id
),
MaxCount AS (
    SELECT MAX(purchase_count) AS max_count
    FROM ProductCounts
)
SELECT p.product_id, p.purchase_count
FROM ProductCounts p
JOIN MaxCount m 
  ON p.purchase_count = m.max_count;
