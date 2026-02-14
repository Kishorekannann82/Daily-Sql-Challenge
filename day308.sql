/*
Kaplan–Meier Survival Curve Construction in SQL

(Yes… full survival curve in pure SQL 😄)

Used in churn modeling, reliability engineering, medical analytics, SaaS retention.

📊 Scenario

You track user start dates and churn dates.

users
user_id	start_date	churn_date
101	2024-01-01	2024-01-20
102	2024-01-01	NULL
103	2024-01-01	2024-02-10
104	2024-01-01	2024-01-15
105	2024-01-01	NULL

📌 Observation end date: 2024-03-01
If churn_date IS NULL → right-censored

🎯 Goal

Construct Kaplan–Meier survival table:

For each churn time:

time_days

users_at_risk

churn_events

survival_probability

🧠 Kaplan–Meier Formula

At time t:

𝑆
(
𝑡
)
=
∏
(
1
−
𝑑
𝑖
𝑛
𝑖
)
S(t)=∏(1−
n
i
	​

d
i
	​

	​

)

Where:

𝑑
𝑖
d
i
	​

 = churn events at time i

𝑛
𝑖
n
i
	​
*/
 = users at risk just before time i

✅ Expected SQL Answer

(Works in PostgreSQL / MySQL 8+ / SQL Server)

WITH base AS (
    SELECT
        user_id,
        start_date,
        COALESCE(churn_date, '2024-03-01') AS end_date,
        CASE WHEN churn_date IS NULL THEN 0 ELSE 1 END AS event_flag,
        DATEDIFF(
            COALESCE(churn_date, '2024-03-01'),
            start_date
        ) AS time_days
    FROM users
),
event_times AS (
    SELECT
        time_days,
        COUNT(*) AS churn_events
    FROM base
    WHERE event_flag = 1
    GROUP BY time_days
),
risk_set AS (
    SELECT
        e.time_days,
        e.churn_events,
        (
            SELECT COUNT(*)
            FROM base b
            WHERE b.time_days >= e.time_days
        ) AS users_at_risk
    FROM event_times e
),
km_calc AS (
    SELECT
        time_days,
        users_at_risk,
        churn_events,
        (1.0 - churn_events * 1.0 / users_at_risk) AS survival_step
    FROM risk_set
)
SELECT
    time_days,
    users_at_risk,
    churn_events,
    ROUND(
        EXP(
            SUM(LOG(survival_step)) OVER (
                ORDER BY time_days
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            )
        ),
        4
    ) AS survival_probability
FROM km_calc
ORDER BY time_days;