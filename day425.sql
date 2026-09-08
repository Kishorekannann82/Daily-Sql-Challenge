/*
📌 Challenge 2.0 — Day 31: "Customer Lifetime Value (CLV) Percentile Ranking with Cohort Context"

Scenario:
You're a Data Analyst at a subscription box company. Finance wants to identify high-value customers relative to their signup cohort — since a customer who signed up 3 years ago naturally has more lifetime revenue than one who joined last month, comparing raw CLV company-wide is unfair. They want each customer's CLV percentile within their own signup-month cohort.

Table: customers

Column	Type
customer_id	INT
signup_date	DATE

Table: orders

Column	Type
order_id	INT
customer_id	INT
order_date	DATE
order_amount	DECIMAL

Task: For each customer, calculate their total lifetime spend (clv) and their percentile rank within their signup cohort (signup month). Flag customers in the top 10% of their cohort as 'High Value'. Output customer_id, signup_cohort, clv, cohort_percentile, value_tier.
*/
WITH customer_clv AS (
    SELECT 
        c.customer_id,
        DATE_TRUNC('month', c.signup_date) AS signup_cohort,
        COALESCE(SUM(o.order_amount), 0) AS clv
    FROM customers c
    LEFT JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', c.signup_date)
),
ranked AS (
    SELECT 
        customer_id,
        signup_cohort,
        clv,
        PERCENT_RANK() OVER (
            PARTITION BY signup_cohort 
            ORDER BY clv
        ) AS cohort_percentile
    FROM customer_clv
)
SELECT 
    customer_id,
    signup_cohort,
    clv,
    ROUND(cohort_percentile * 100, 1) AS cohort_percentile,
    CASE 
        WHEN cohort_percentile >= 0.90 THEN 'High Value'
        ELSE 'Standard'
    END AS value_tier
FROM ranked
ORDER BY signup_cohort, clv DESC;
