/*
🧠 Challenge: Customers Who Bought All Products in a Category
🗃️ Tables:
Products (
  product_id INT,
  category_id INT,
  product_name VARCHAR(50)
)

Orders (
  order_id INT,
  customer_id INT,
  product_id INT,
  order_date DATE
)

🎯 Task:

Find all customers who have purchased every product in at least one category.

✅ Example Data

Products

product_id	category_id	product_name
1	10	Laptop
2	10	Mouse
3	10	Keyboard
4	20	Phone
5	20	Charger

Orders

order_id	customer_id	product_id	order_date
101	1	1	2023-01-05
102	1	2	2023-01-06
103	1	3	2023-01-10
104	2	1	2023-01-08
105	2	2	2023-01-09
106	3	4	2023-02-01
✅ Expected Output
customer_id	category_id
1	10

(Customer 1 bought all 3 products in category 10.)

✅ MySQL Answer
*/

WITH CategoryCount AS (
    SELECT category_id, COUNT(DISTINCT product_id) AS total_products
    FROM Products
    GROUP BY category_id
),
CustomerCategory AS (
    SELECT 
        o.customer_id,
        p.category_id,
        COUNT(DISTINCT o.product_id) AS purchased_products
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    GROUP BY o.customer_id, p.category_id

)
SELECT      
    cc.customer_id,
    cc.category_id

FROM CustomerCategory cc
JOIN CategoryCount ccount ON cc.category_id = ccount.category_id
WHERE cc.purchased_products = ccount.total_products
ORDER BY cc.customer_id, cc.category_id;
-- Question: