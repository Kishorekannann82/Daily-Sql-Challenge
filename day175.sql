/*
🧠 Challenge: Customer Churn (Inactive Users)
🗃️ Table:
*/
Purchases (
  purchase_id INT,
  user_id INT,
  purchase_date DATE,
  amount DECIMAL(10,2)
)
/*🎯 Task:

Find all users who have not made any purchase in the last 30 days (relative to the maximum purchase date in the dataset).\\
Return their user_id and the date of their last purchase.
*/  
WITH LastPurchase AS (
    SELECT 
        MAX(purchase_date) AS max_date
    FROM Purchases
)
SELECT DISTINCT p.user_id
FROM Purchases p, LastPurchase lp
WHERE p.user_id NOT IN (
    SELECT user_id
    FROM Purchases
    WHERE purchase_date >= DATE_SUB(lp.max_date, INTERVAL 30 DAY)
);
