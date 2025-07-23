/*
🧠 Challenge: Find the First Product Purchased by Each User
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
For each user, return the product they purchased first (by purchase_date).
If a user bought multiple products on their first date, return any one of them.
*/
with Rank as(
    SELECT user_id,product_id,purchase_date,
    row_number() over(partition by product_id order by purchase_date asc,purchase_id asc) as rn 
    from Purchases
)
SELECT *
from Rank
where rn=1 ;

