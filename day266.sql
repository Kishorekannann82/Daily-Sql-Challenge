/*
Prorated Subscription Billing
Scenario

Customers subscribe to a paid plan. Billing is monthly.
If a subscription starts or ends mid-month, they are billed pro rata.

subscriptions

sub_id	customer_id	start_date	end_date	monthly_fee
1	101	2024-01-10	2024-03-05	100
2	102	2024-02-15	NULL	150
3	103	2024-03-01	2024-03-31	200
📌 Rules

Billing is done monthly with:

prorated_fee = monthly_fee * (active_days_in_month / total_days_in_month)


If end_date is NULL → subscription still active → bill until current month '2024-04-01'.

❓ Question

Generate one billing record per customer per active month:

Return:

customer_id

billing_month

active_days

total_days

prorated_fee

✅ Expected SQL Answer (PostgreSQL version)
*/
WITH date_bounds AS (
    SELECT
        customer_id,
        start_date,
        COALESCE(end_date, '2024-04-01') AS end_date,
        monthly_fee
    FROM subscriptions
),
expanded AS (
    -- Generate months between start & end for each subscription
    SELECT
        d.customer_id,
        d.monthly_fee,
        g::date AS month_start,
        (g + interval '1 month - 1 day')::date AS month_end,
        d.start_date,
        d.end_date
    FROM date_bounds d
    CROSS JOIN LATERAL generate_series(
        date_trunc('month', start_date),
        date_trunc('month', end_date),
        interval '1 month'
    ) g
),
prorated AS (
    SELECT
        customer_id,
        TO_CHAR(month_start, 'YYYY-MM') AS billing_month,
        GREATEST(start_date, month_start) AS active_start,
        LEAST(end_date, month_end) AS active_end,
        monthly_fee,
        (month_end - month_start + 1) AS total_days,
        (LEAST(end_date, month_end) - GREATEST(start_date, month_start) + 1) AS active_days
    FROM expanded
)
SELECT
    customer_id,
    billing_month,
    active_days,
    total_days,
    ROUND(monthly_fee * (active_days::float / total_days), 2) AS prorated_fee
FROM prorated
ORDER BY customer_id, billing_month;