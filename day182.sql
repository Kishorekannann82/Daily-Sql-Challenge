/*
🧠 Challenge: Top 3 Products by Revenue
🗃️ Tables:
*/
Products (
  product_id INT,
  product_name VARCHAR(50),
  price DECIMAL(10,2)
)

OrderItems (
  order_item_id INT,
  order_id INT,
  product_id INT,
  quantity INT
)
/*
🎯 Task:

Find the top 3 products that generated the highest total revenue.
*/
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM OrderItems oi
JOIN Products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;
-- End of code