/*
Measure Treatment Impact Using Diff-in-Diff
Scenario

A new feature was launched on 2024-02-01 for a treatment group.
You want to measure its impact on revenue per user compared to a control group.

user_revenue
user_id	group_type	revenue_date	revenue
101	treatment	2024-01-10	100
101	treatment	2024-02-10	160
102	treatment	2024-01-15	120
102	treatment	2024-02-18	170
201	control	2024-01-12	110
201	control	2024-02-12	115
202	control	2024-01-20	130
202	control	2024-02-22	135

📌 Definitions

Pre-period → before 2024-02-01

Post-period → on/after 2024-02-01

DiD Effect:

(treatment_post − treatment_pre)
− (control_post − control_pre)

❓ Goal

Compute the causal impact of the feature launch.

Return:

treatment_pre_avg

treatment_post_avg

control_pre_avg

control_post_avg

diff_in_diff_effect

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH labeled AS (
    SELECT
        group_type,
        CASE
            WHEN revenue_date < '2024-02-01' THEN 'PRE'
            ELSE 'POST'
        END AS period,
        revenue
    FROM user_revenue
),
aggregated AS (
    SELECT
        group_type,
        period,
        AVG(revenue) AS avg_revenue
    FROM labeled
    GROUP BY group_type, period
),
pivoted AS (
    SELECT
        MAX(CASE WHEN group_type = 'treatment' AND period = 'PRE'
            THEN avg_revenue END) AS treatment_pre,
        MAX(CASE WHEN group_type = 'treatment' AND period = 'POST'
            THEN avg_revenue END) AS treatment_post,
        MAX(CASE WHEN group_type = 'control' AND period = 'PRE'
            THEN avg_revenue END) AS control_pre,
        MAX(CASE WHEN group_type = 'control' AND period = 'POST'
            THEN avg_revenue END) AS control_post
    FROM aggregated
)
SELECT
    treatment_pre,
    treatment_post,
    control_pre,
    control_post,
    (treatment_post - treatment_pre)
      - (control_post - control_pre) AS diff_in_diff_effect
FROM pivoted;