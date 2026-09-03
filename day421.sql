/*
Challenge 2.0 — Day 27: "Weighted Average Rating with Recency Decay"

Scenario:
You're a Data Analyst at a marketplace app (like Amazon). Product wants a smarter product rating score than a plain average — older reviews should count less than recent ones, since product quality/seller behavior can change over time. They've defined a simple decay rule: a review's weight is 1 / (1 + months_since_review).

Table: reviews

Column	Type
review_id	INT
product_id	INT
rating	INT
review_date	DATE

Task: Calculate a recency-weighted average rating per product, as of today (CURRENT_DATE). Output product_id, simple_avg_rating, weighted_avg_rating, review_count — so the team can compare both side by side.
*/
WITH weighted AS (
    SELECT 
        product_id,
        rating,
        (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM review_date)) * 12 
            + (EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM review_date)) AS months_since_review
    FROM reviews
),
scored AS (
    SELECT 
        product_id,
        rating,
        1.0 / (1 + months_since_review) AS weight
    FROM weighted
)
SELECT 
    product_id,
    ROUND(AVG(rating), 2) AS simple_avg_rating,
    ROUND(SUM(rating * weight) / SUM(weight), 2) AS weighted_avg_rating,
    COUNT(*) AS review_count
FROM scored
GROUP BY product_id
ORDER BY product_id;
