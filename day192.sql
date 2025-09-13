
/*
🧠 Challenge: Top 3 Products by Revenue Per Month
🗃️ Tables:
*/

Orders (
  order_id INT,
  order_date DATE
)

OrderItems (
  order_item_id INT,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2)
)
/*
🎯 Task:

For each month, find the top 3 products by revenue.
Revenue = quantity × price.

✅ Example Data:

Orders

order_id	order_date
101	2023-01-05
102	2023-01-15
103	2023-02-03
104	2023-02-20

OrderItems

order_item_id	order_id	product_id	quantity	price
1	101	1	2	100.00
2	101	2	1	200.00
3	102	1	3	100.00
4	103	2	2	200.00
5	104	3	5	50.00
✅ Expected Output:
month	product_id	total_revenue
2023-01	1	500.00
2023-01	2	200.00
2023-02	2	400.00
2023-02	3	250.00
*/
-- ✅ MySQL Answer:
WITH ProductRevenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        oi.product_id,
        SUM(oi.quantity * oi.price) AS total_revenue
    FROM Orders o
    JOIN OrderItems oi ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), oi.product_id
),
Ranked AS (
    SELECT 
        month,
        product_id,
        total_revenue,
        RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rnk
    FROM ProductRevenue
)
SELECT month, product_id, total_revenue
FROM Ranked
WHERE rnk <= 3
ORDER BY month, total_revenue DESC;