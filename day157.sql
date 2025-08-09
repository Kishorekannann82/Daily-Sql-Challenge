/*
🧠 Challenge: First Product Purchased per User
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
For each user, return the first product they purchased (based on purchase_date).
*/
SELECT 
    user_id,
    product_id,
    purchase_date AS first_purchase_date
FROM Purchases p
WHERE purchase_date = (
    SELECT MIN(p2.purchase_date)
    FROM Purchases p2
    WHERE p2.user_id = p.user_id
);
