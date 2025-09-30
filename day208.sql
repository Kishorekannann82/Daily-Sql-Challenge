/*
🧠 Challenge: Most Frequently Purchased Product per User
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
For each user, return the product they purchased most frequently.
If there's a tie, return any one of the most frequent products.

✅ Expected Output:
user_id	product_id	purchase_count
1	101	5
2	205	3
3	302	2

*/
With ProductCounts as(
    select user_id,
    product_id,
    count(*) as purchasse_count
    from Purchases
    group by user_id,product_id
),
RankedProducts(
    select *,
    ROW_NUMBER() over(partition by user_id order by purchase_count desc) as rn
    from ProductCounts
)
SELECT *
from RankedProducts
where rn=1
