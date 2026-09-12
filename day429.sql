/*
📌 Challenge 2.0 — Day 35: "Time-to-First-Purchase After Signup (Conversion Speed)"

Scenario:
You're a Data Analyst at an e-commerce startup. Growth wants to understand how quickly new users convert — specifically, bucket every user by how many days it took from signup to their first purchase, so they can see if a "welcome discount" campaign is actually accelerating conversion.

Table: users

Column	Type
user_id	INT
signup_date	DATE

Table: orders

Column	Type
order_id	INT
user_id	INT
order_date	DATE

Task: For every user, calculate days_to_first_purchase (NULL if they've never purchased), bucket it into 'Same day', '1-3 days', '4-7 days', '8-30 days', '30+ days', or 'Never purchased'. Output bucket, user_count, pct_of_all_users — ordered logically.
*/
WITH first_purchase AS (
    SELECT 
        user_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY user_id
),
user_conversion AS (
    SELECT 
        u.user_id,
        CASE 
            WHEN fp.first_order_date IS NULL THEN NULL
            ELSE fp.first_order_date - u.signup_date
        END AS days_to_first_purchase
    FROM users u
    LEFT JOIN first_purchase fp 
        ON u.user_id = fp.user_id
),
bucketed AS (
    SELECT 
        user_id,
        CASE 
            WHEN days_to_first_purchase IS NULL THEN 'Never purchased'
            WHEN days_to_first_purchase = 0 THEN 'Same day'
            WHEN days_to_first_purchase BETWEEN 1 AND 3 THEN '1-3 days'
            WHEN days_to_first_purchase BETWEEN 4 AND 7 THEN '4-7 days'
            WHEN days_to_first_purchase BETWEEN 8 AND 30 THEN '8-30 days'
            ELSE '30+ days'
        END AS bucket,
        CASE 
            WHEN days_to_first_purchase IS NULL THEN 6
            WHEN days_to_first_purchase = 0 THEN 1
            WHEN days_to_first_purchase BETWEEN 1 AND 3 THEN 2
            WHEN days_to_first_purchase BETWEEN 4 AND 7 THEN 3
            WHEN days_to_first_purchase BETWEEN 8 AND 30 THEN 4
            ELSE 5
        END AS bucket_order
    FROM user_conversion
),
total AS (
    SELECT COUNT(*) AS total_users FROM users
)
SELECT 
    b.bucket,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / t.total_users, 2) AS pct_of_all_users
FROM bucketed b
CROSS JOIN total t
GROUP BY b.bucket, b.bucket_order, t.total_users
ORDER BY b.bucket_order;
