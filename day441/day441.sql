/*
📌 Challenge 2.0 — Day 46: "Warranty Claim Clustering — Defective Batch Detection"

Scenario:
You're a Data Analyst at a manufacturing company. Quality control suspects a defective production batch — they want to know if warranty claims are clustering around products manufactured in a specific week, rather than being randomly distributed across all manufacturing dates (which would suggest a systemic issue vs. normal random failures).

Table: products

Column	Type
product_id	INT
manufacture_date	DATE

Table: warranty_claims

Column	Type
claim_id	INT
product_id	INT
claim_date	DATE

Task: For each manufacturing week, calculate the claim rate (claims / units manufactured that week). Flag a week as 'Defective Batch Suspected' if its claim rate is more than 3x the overall average claim rate across all weeks, and it has at least 20 units manufactured (avoid flagging tiny batches from natural noise). Output manufacture_week, units_manufactured, claims_count, claim_rate, flag.
*/
WITH weekly_production AS (
    SELECT 
        DATE_TRUNC('week', manufacture_date) AS manufacture_week,
        product_id
    FROM products
),
units_per_week AS (
    SELECT 
        manufacture_week,
        COUNT(*) AS units_manufactured
    FROM weekly_production
    GROUP BY manufacture_week
),
claims_per_week AS (
    SELECT 
        wp.manufacture_week,
        COUNT(wc.claim_id) AS claims_count
    FROM weekly_production wp
    LEFT JOIN warranty_claims wc 
        ON wp.product_id = wc.product_id
    GROUP BY wp.manufacture_week
),
combined AS (
    SELECT 
        upw.manufacture_week,
        upw.units_manufactured,
        COALESCE(cpw.claims_count, 0) AS claims_count,
        COALESCE(cpw.claims_count, 0) * 1.0 / upw.units_manufactured AS claim_rate
    FROM units_per_week upw
    LEFT JOIN claims_per_week cpw 
        ON upw.manufacture_week = cpw.manufacture_week
),
overall_avg AS (
    SELECT 
        SUM(claims_count) * 1.0 / SUM(units_manufactured) AS avg_claim_rate
    FROM combined
)
SELECT 
    c.manufacture_week,
    c.units_manufactured,
    c.claims_count,
    ROUND(c.claim_rate, 4) AS claim_rate,
    CASE 
        WHEN c.units_manufactured >= 20 
             AND c.claim_rate > 3 * oa.avg_claim_rate 
        THEN 'Defective Batch Suspected'
        ELSE 'Normal'
    END AS flag
FROM combined c
CROSS JOIN overall_avg oa
ORDER BY c.manufacture_week;
🧠 Why it works:
