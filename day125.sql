/*
🧠 Challenge: Users Who Purchased All Products
🗃️ Table: Purchases
*/
Purchases (
    user_id INT,
    product_id INT,
    purchase_date DATE
)
/*
🎯 Your Task:
Find users who have purchased every product available in the Purchases table (i.e., users who bought all products).
*/
with TotalProducts as (
    select count(Distinct product_id) as total_products 
    from Purchases
)
select user_id
from Purchases,TotalProducts
group by user_id
having count(Distinct product_id) = total_products;