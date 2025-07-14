/*
🧠 Challenge: User Purchase Retention
🗃️ Table: Purchases
*/
Purchases (
    user_id INT,
    purchase_date DATE
)
/*
🎯 Your Task:
Calculate user retention over the first 3 months after a user’s first purchase.

For each user, output:

user_id

first_month (month of first purchase)

month_1_active (1 if purchased in first month, else 0)

month_2_active (1 if purchased in second month, else 0)

month_3_active (1 if purchased in third month, else 0)

✅ Expected Output:
| user\_id | first\_month | month\_1\_active | month\_2\_active | month\_3\_active |
| -------- | ------------ | ---------------- | ---------------- | ---------------- |
| 101      | 2024-01      | 1                | 1                | 0                |
| 102      | 2024-02      | 1                | 0                | 1                |
*/

WITH FirstPurchase AS (
  SELECT 
    user_id,
    MIN(purchase_date) AS first_purchase_date
  FROM Purchases
  GROUP BY user_id
),
LabeledPurchases AS (
  SELECT 
    p.user_id,
    f.first_purchase_date,
    p.purchase_date,
    TIMESTAMPDIFF(MONTH, f.first_purchase_date, p.purchase_date) + 1 AS month_number
  FROM Purchases p
  JOIN FirstPurchase f ON p.user_id = f.user_id
  WHERE TIMESTAMPDIFF(MONTH, f.first_purchase_date, p.purchase_date) < 3
),
MonthFlags AS (
  SELECT 
    user_id,
    MAX(CASE WHEN month_number = 1 THEN 1 ELSE 0 END) AS month_1_active,
    MAX(CASE WHEN month_number = 2 THEN 1 ELSE 0 END) AS month_2_active,
    MAX(CASE WHEN month_number = 3 THEN 1 ELSE 0 END) AS month_3_active
  FROM LabeledPurchases
  GROUP BY user_id
)
SELECT 
  f.user_id,
  DATE_FORMAT(f.first_purchase_date, '%Y-%m') AS first_month,
  m.month_1_active,
  m.month_2_active,
  m.month_3_active
FROM FirstPurchase f
LEFT JOIN MonthFlags m ON f.user_id = m.user_id
ORDER BY f.user_id;
