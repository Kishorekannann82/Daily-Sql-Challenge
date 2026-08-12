/*
Challenge 2.0 — Day 6: "Customer Cohort Retention"

Scenario:
You're a Data Analyst at a SaaS company. The growth team wants a cohort retention table — group customers by the month they signed up (their cohort), then track what percentage of each cohort was still active (made at least one transaction) in each subsequent month.

Table: customers

Column	Type
customer_id	INT
signup_date	DATE

Table: transactions

Column	Type
transaction_id	INT
customer_id	INT
transaction_date	DATE

Task: For each cohort (signup month), calculate retention for month 0, 1, 2, 3 after signup (month 0 = signup month itself). Output cohort_month, months_since_signup, active_customers, cohort_size, retention_rate.

✅ Solution
sql
*/

WITH cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM customers
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM cohorts
    GROUP BY cohort_month
),
activity AS (
    SELECT DISTINCT
        c.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', t.transaction_date) AS activity_month
    FROM cohorts c
    JOIN transactions t 
        ON c.customer_id = t.customer_id
),
monthly_activity AS (
    SELECT 
        cohort_month,
        (EXTRACT(YEAR FROM activity_month) - EXTRACT(YEAR FROM cohort_month)) * 12 
            + (EXTRACT(MONTH FROM activity_month) - EXTRACT(MONTH FROM cohort_month)) AS months_since_signup,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM activity
    GROUP BY cohort_month, months_since_signup
)
SELECT 
    ma.cohort_month,
    ma.months_since_signup,
    ma.active_customers,
    cs.cohort_size,
    ROUND(ma.active_customers * 100.0 / cs.cohort_size, 2) AS retention_rate
FROM monthly_activity ma
JOIN cohort_sizes cs 
    ON ma.cohort_month = cs.cohort_month
WHERE ma.months_since_signup BETWEEN 0 AND 3
ORDER BY ma.cohort_month, ma.months_since_signup;
