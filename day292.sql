/*
Build a Simple Recommendation Score (Users × Items)
Scenario

You track which users purchased which products.

purchases

user_id	product_id
1	A
1	B
2	A
2	C
3	B
3	C
3	D
4	A
4	B

📌 Idea (Item-based Collaborative Filtering – simplified)
Recommend products to a user based on:

Products bought by similar users

Similarity = number of shared products

❓ Goal

For user 1, recommend products they haven’t purchased yet, ranked by score.

Scoring logic:

score(product) =
  number of times the product is purchased
  by users who share ≥1 product with user 1

✅ Expected SQL Answer
*/

-- Step 1: products bought by target user (user 1)
WITH user_products AS (
    SELECT product_id
    FROM purchases
    WHERE user_id = 1
),

-- Step 2: find similar users (shared products)
similar_users AS (
    SELECT DISTINCT p.user_id
    FROM purchases p
    JOIN user_products up
      ON p.product_id = up.product_id
    WHERE p.user_id <> 1
),

-- Step 3: candidate products from similar users
candidate_products AS (
    SELECT
        p.product_id,
        COUNT(*) AS score
    FROM purchases p
    JOIN similar_users su
      ON p.user_id = su.user_id
    WHERE p.product_id NOT IN (
        SELECT product_id FROM user_products
    )
    GROUP BY p.product_id
)

SELECT
    product_id,
    score
FROM candidate_products
ORDER BY score DESC;