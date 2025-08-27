/*
🧠 Challenge: Top 3 Products by Revenue per Month
🗃️ Tables:
*/
Orders (
  order_id INT,
  order_date DATE
);

OrderItems (
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2)
);
/*
🎯 Task:

For each month, find the top 3 products that generated the most revenue.
*/
WITH Revenue AS (
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
        RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rn
    FROM Revenue
)
SELECT 
    month,
    product_id,
    total_revenue
FROM Ranked
WHERE rn <= 3;
