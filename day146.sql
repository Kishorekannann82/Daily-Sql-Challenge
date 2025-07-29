/*
🧠 Challenge: Top-Selling Product Each Month
🗃️ Table: Sales
*/
Sales (
  sale_id INT,
  product_id INT,
  sale_date DATE,
  quantity INT
)
/*
🎯 Task:
Find the top-selling product by quantity for each month.

Return:

sale_month (YYYY-MM format)

product_id

total_quantity

If multiple products are tied for top sales in a month, return any one of them.
*/
WITH MonthlySales AS (
  SELECT 
    product_id,
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(quantity) AS total_quantity
  FROM Sales
  GROUP BY product_id, DATE_FORMAT(sale_date, '%Y-%m')
),
RankedSales AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY sale_month
      ORDER BY total_quantity DESC
    ) AS rn
  FROM MonthlySales
)
SELECT 
  sale_month,
  product_id,
  total_quantity
FROM RankedSales
WHERE rn = 1;
