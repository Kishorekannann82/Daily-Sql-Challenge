/*
📌 Challenge 2.0 — Day 28: "Customer Segmentation — RFM Analysis"

Scenario:
You're a Data Analyst at an e-commerce company. Marketing wants classic RFM segmentation (Recency, Frequency, Monetary) to target campaigns — customers scored 1-5 on each dimension (5 = best), then combined into a segment label for the top and bottom groups.

Table: orders

Column	Type
order_id	INT
customer_id	INT
order_date	DATE
order_amount	DECIMAL

Task: For each customer, calculate: Recency (days since last order, scored 1-5 where 5 = most recent), Frequency (total order count, scored 1-5 where 5 = most orders), Monetary (total spend, scored 1-5 where 5 = highest spend) — using quintiles. Then flag 'Champion' (5-5-5, 5-5-4, 5-4-5, 4-5-5) and 'At Risk' (R score ≤ 2 but F and M scores ≥ 4). Output customer_id, recency_score, frequency_score, monetary_score, segment.
*/
WITH customer_metrics AS (
    SELECT 
        customer_id,
        DATEDIFF(CURRENT_DATE, MAX(order_date)) AS recency_days,
        COUNT(*) AS frequency,
        SUM(order_amount) AS monetary
    FROM orders
    GROUP BY customer_id
),
scored AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary,
        -- Recency: LOWER days = BETTER, so reverse the quintile direction
        6 - NTILE(5) OVER (ORDER BY recency_days) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary) AS monetary_score
    FROM customer_metrics
)
SELECT 
    customer_id,
    recency_score,
    frequency_score,
    monetary_score,
    CASE 
        WHEN (recency_score, frequency_score, monetary_score) IN (
            (5,5,5), (5,5,4), (5,4,5), (4,5,5)
        ) THEN 'Champion'
        WHEN recency_score <= 2 AND frequency_score >= 4 AND monetary_score >= 4 
            THEN 'At Risk'
        ELSE 'Standard'
    END AS segment
FROM scored
ORDER BY segment, customer_id;
