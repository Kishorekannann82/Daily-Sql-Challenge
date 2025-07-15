/*
🧠 Challenge: Users Who Purchased the Same Product in Consecutive Months
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
For each user and product, identify the cases where the same product was purchased in two consecutive months.


✅ Expected Output:
| user\_id | product\_id | month1  | month2  |
| -------- | ----------- | ------- | ------- |
| 101      | 55          | 2023-01 | 2023-02 |
| 102      | 88          | 2024-03 | 2024-04 |
*/
WITH PurchaseMonths AS (
  SELECT
    user_id,
    product_id,
    DATE_FORMAT(purchase_date, '%Y-%m') AS purchase_month
  FROM Purchases
  GROUP BY user_id, product_id, DATE_FORMAT(purchase_date, '%Y-%m')
),
WithMonthNumber AS (
  SELECT 
    user_id,
    product_id,
    purchase_month,
    ROW_NUMBER() OVER (PARTITION BY user_id, product_id ORDER BY purchase_month) AS rn
  FROM PurchaseMonths
),
JoinConsecutive AS (
  SELECT 
    p1.user_id,
    p1.product_id,
    p1.purchase_month AS month1,
    p2.purchase_month AS month2
  FROM WithMonthNumber p1
  JOIN WithMonthNumber p2
    ON p1.user_id = p2.user_id 
    AND p1.product_id = p2.product_id
    AND p1.rn = p2.rn - 1
)
SELECT *
FROM JoinConsecutive
WHERE PERIOD_DIFF(REPLACE(month2, '-', ''), REPLACE(month1, '-', '')) = 1;