/*
🧠 Challenge: First Product Each User Bought in Each Month
🗃️ Table: Purchases
*/
Purchases (
    purchase_id INT,
    user_id INT,
    product_id INT,
    purchase_date DATE
)
/*
🎯 Your Task:
For each user and month, return the first product they purchased (by purchase date).
If a user made multiple purchases on the same first date, return any one of those.
*/
WITH Ranked AS (
  SELECT *,
         DATE_FORMAT(purchase_date, '%Y-%m') AS month,
         ROW_NUMBER() OVER (
             PARTITION BY user_id, DATE_FORMAT(purchase_date, '%Y-%m') 
             ORDER BY purchase_date
         ) AS rn
  FROM Purchases
)
SELECT user_id, month, product_id, purchase_date AS first_purchase_date
FROM Ranked
WHERE rn = 1
ORDER BY user_id, month;
