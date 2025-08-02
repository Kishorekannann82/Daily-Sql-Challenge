/*
🧠 Challenge: Top 2 Products by Revenue per Month
🗃️ Tables:
*/
Orders (
  order_id INT,
  order_date DATE
)

OrderItems (
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2)
)
/*
🎯 Task:
For each month, find the top 2 products based on total revenue (quantity × price).
Return the following:

month (format YYYY-MM)

product_id

total_revenue

rank (1 or 2)
*/
WITH RevenuePerProduct AS (
  SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    oi.product_id,
    SUM(oi.quantity * oi.price) AS total_revenue
  FROM Orders o
  JOIN OrderItems oi ON o.order_id = oi.order_id
  GROUP BY month, oi.product_id
),
RankedProducts AS (
  SELECT 
    *,
    RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rank
  FROM RevenuePerProduct
)
SELECT 
  month,
  product_id,
  total_revenue,
  rank
FROM RankedProducts
WHERE rank <= 2
ORDER BY month, rank;
