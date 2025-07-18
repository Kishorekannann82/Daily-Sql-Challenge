/*
🧠 Challenge: Products Purchased by All Users
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
Find the products that were purchased by every user in the table at least once.
*/
SELECT product_id
FROM Purchases
GROUP BY product_id
HAVING COUNT(DISTINCT user_id) = (SELECT COUNT(DISTINCT user_id) FROM Purchases);
