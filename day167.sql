/*
🧠 Challenge: First and Last Purchase per User
🗃️ Table: Purchases
*/
Purchases (
  purchase_id INT,
  user_id INT,
  product_id INT,
  purchase_date DATE
);
/*
🎯 Task:

For each user, find their first purchase date and last purchase date

*/
select user_id,
Min(purchase_date) as first_purchase,
MAX(purchase_date) as last_purchase
from Purchases