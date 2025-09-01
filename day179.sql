/*
🧠 Challenge: Top 3 Products by Sales
🗃️ Table:
*/
OrderItems (
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2)
)
/*
🎯 Task:

Find the top 3 products that generated the highest total revenue (quantity × price).
*/
SELECT 
    product_id,
    SUM(quantity * price) AS total_revenue
FROM OrderItems
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 3;
