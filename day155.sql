/*
🧠 Challenge: First Product Purchased Per Month
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
For each user and for each month, return the first product they purchased.

✅ Output columns:

user_id

month (YYYY-MM format)

first_product_id

first_purchase_date
*/
WITH RankedPurchases AS (
  SELECT
    user_id,
    product_id,
    DATE_FORMAT(purchase_date, '%Y-%m') AS month,
    purchase_date,
    RANK() OVER (
      PARTITION BY user_id, DATE_FORMAT(purchase_date, '%Y-%m')
      ORDER BY purchase_date
    ) AS rnk
  FROM Purchases
)

SELECT
  user_id,
  month,
  product_id AS first_product_id,
  purchase_date AS first_purchase_date
FROM RankedPurchases
WHERE rnk = 1
ORDER BY user_id, month;
