/*
🧠 Challenge: First Purchase per User Each Month
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
For each user and each month, find the first product they purchased (i.e., the earliest purchase_date in that month).

Return the following columns:

user_id

purchase_month (formatted as 'YYYY-MM')

product_id

purchase_date
*/
WITH RankedPurchases AS (
  SELECT 
    user_id,
    product_id,
    purchase_date,
    DATE_FORMAT(purchase_date, '%Y-%m') AS purchase_month,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, DATE_FORMAT(purchase_date, '%Y-%m')
      ORDER BY purchase_date
    ) AS rn
  FROM Purchases
)
SELECT 
  user_id,
  purchase_month,
  product_id,
  purchase_date
FROM RankedPurchases
WHERE rn = 1;
