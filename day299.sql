/*
Build Survival / Hazard Features in SQL
Scenario

You track when users start and when they churn (or are still active).

users

user_id	start_date	churn_date
101	2024-01-01	2024-02-15
102	2024-01-10	NULL
103	2024-01-20	2024-03-01
104	2024-02-01	NULL
105	2024-02-05	2024-02-20

📌 Assumptions

Observation end date = 2024-04-01

If churn_date is NULL → user is right-censored

We want time-to-event features

❓ Goal

For each user, compute:

tenure_days → days active until churn or censoring

event_flag → 1 if churned, 0 if censored

monthly_hazard_proxy → event_flag / tenure_months

Return:

user_id

tenure_days

tenure_months

event_flag

monthly_hazard_proxy

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH base AS (
    SELECT
        user_id,
        start_date,
        COALESCE(churn_date, '2024-04-01') AS end_date,
        CASE
            WHEN churn_date IS NULL THEN 0
            ELSE 1
        END AS event_flag
    FROM users
),
tenure AS (
    SELECT
        user_id,
        event_flag,
        DATEDIFF(end_date, start_date) AS tenure_days,
        TIMESTAMPDIFF(MONTH, start_date, end_date) + 1 AS tenure_months
    FROM base
)
SELECT
    user_id,
    tenure_days,
    tenure_months,
    event_flag,
    ROUND(event_flag * 1.0 / tenure_months, 4) AS monthly_hazard_proxy
FROM tenure
ORDER BY user_id;