/*
🧠 Challenge: Monthly Revenue per Product
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
  price DECIMAL(10, 2)
)
/*
🎯 Task:
For each product, calculate the total revenue per month.
Sort by product_id and then by month.
*/
SELECT 
    oi.product_id,
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM Orders o
JOIN OrderItems oi 
    ON o.order_id = oi.order_id
GROUP BY 
    oi.product_id,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY 
    oi.product_id,
    month;
