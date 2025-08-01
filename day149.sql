/*
🧠 Challenge: First Purchase Product Per Month
🗃️ Table: Purchases
*/
Purchases (
  purchase_id INT,
  user_id INT,
  product_id INT,
  purchase_date DATE
)
/*

🎯 Task:
For each user and each month, return the first product they purchased in that month.

Return:

user_id

month (as YYYY-MM)

first_product_id

first_purchase_date


*/
WITH MonthlyPurchases AS (
  SELECT 
    user_id,
    product_id,
    purchase_date,
    DATE_FORMAT(purchase_date, '%Y-%m') AS month,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, DATE_FORMAT(purchase_date, '%Y-%m')
      ORDER BY purchase_date ASC
    ) AS rn
  FROM Purchases
)
SELECT 
  user_id,
  month,
  product_id AS first_product_id,
  purchase_date AS first_purchase_date
FROM MonthlyPurchases
WHERE rn = 1;
