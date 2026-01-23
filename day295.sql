/*
Build Churn Risk Features in SQL
Scenario

You want to generate churn features per user based on their activity history.

user_activity

user_id	activity_date
101	2024-01-01
101	2024-01-10
101	2024-02-01
102	2024-01-05
102	2024-01-06
103	2024-01-01
103	2024-03-15
104	2024-02-01

📌 Assume

Observation date = 2024-04-01

A user is high churn risk if inactive for 30+ days

❓ Goal

For each user, compute these churn features:

1️⃣ Recency → days since last activity
2️⃣ Frequency → total number of activities
3️⃣ Avg gap → average days between activities
4️⃣ Churn flag → YES / NO

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH ordered AS (
    SELECT
        user_id,
        activity_date,
        LAG(activity_date) OVER (
            PARTITION BY user_id
            ORDER BY activity_date
        ) AS prev_activity
    FROM user_activity
),
gaps AS (
    SELECT
        user_id,
        activity_date,
        CASE
            WHEN prev_activity IS NULL THEN NULL
            ELSE DATEDIFF(activity_date, prev_activity)
        END AS gap_days
    FROM ordered
),
features AS (
    SELECT
        user_id,
        MAX(activity_date) AS last_activity,
        COUNT(*) AS frequency,
        AVG(gap_days) AS avg_gap_days
    FROM gaps
    GROUP BY user_id
)
SELECT
    user_id,
    DATEDIFF('2024-04-01', last_activity) AS recency_days,
    frequency,
    ROUND(avg_gap_days, 2) AS avg_gap_days,
    CASE
        WHEN DATEDIFF('2024-04-01', last_activity) >= 30
            THEN 'YES'
        ELSE 'NO'
    END AS churn_risk
FROM features
ORDER BY user_id;