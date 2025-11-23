/*
🧠 Challenge: Top Categories by Revenue
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

Products (
    product_id INT,
    category VARCHAR(255)
)
/*
🎯 Your Task:
Find the top 3 product categories by total revenue for each month.

✅ Expected Output Example:
month	category	total_revenue
2024-01	Electronics	25000.00
2024-01	Fashion	18000.00
2024-01	Sports	15000.00
2024-02	Electronics	32000.00
2024-02	Fashion	19000.00
2024-02	Sports	17000.00

*/
WITH RevenuePerCategory AS (
  SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    p.category,
    SUM(oi.quantity * oi.price) AS total_revenue
  FROM Orders o
  JOIN OrderItems oi ON o.order_id = oi.order_id
  JOIN Products p ON oi.product_id = p.product_id
  GROUP BY month, p.category
),
RankedCategories AS (
  SELECT 
    month,
    category,
    total_revenue,
    RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS revenue_rank
  FROM RevenuePerCategory
)
SELECT 
  month,
  category,
  total_revenue
FROM RankedCategories
WHERE revenue_rank <= 3
ORDER BY month, total_revenue DESC;
