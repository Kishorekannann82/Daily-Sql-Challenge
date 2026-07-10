/*
Monthly cohort retention — who came back Month 1 and Month 2?
You work at a SaaS company. Users sign up and use the product monthly. A cohort is a group of users who signed up in the same month. Find the Month 0 (signup month), Month 1 (1 month later), and Month 2 (2 months later) retention rates for each cohort. Return cohort_month, cohort_size, m1_retained, m1_rate, m2_retained, m2_rate.
Table: user_activity
user_id	activity_month
U01	2024-01
U02	2024-01
U03	2024-01
U04	2024-01
U01	2024-02
U02	2024-02
U04	2024-02
U05	2024-02
U06	2024-02
U01	2024-03
U03	2024-03
U05	2024-03
U07	2024-03
Expected output
cohort_month	cohort_size	m1_retained	m1_rate	m2_retained	m2_rate
2024-01	4	3	75.0	2	50.0
Jan cohort (U01,U02,U03,U04) = 4 users
M1 (Feb): U01✅ U02✅ U04✅ U03❌ → 3 retained → 75.0%
M2 (Mar): U01✅ U03✅ → 2 retained → 50.0%
Feb cohort (U05,U06) = 2 users — only 1 month of follow-up data → not shown
Only Jan cohort has full M1 + M2 data in this dataset ✅
*/
WITH cohorts AS (
  -- Each user's signup month = their cohort
  SELECT
    user_id,
    MIN(activity_month) AS cohort_month
  FROM user_activity
  GROUP BY user_id
),
retention AS (
  SELECT
    c.cohort_month,
    c.user_id,
    -- Was user active in Month 1 after signup?
    MAX(CASE WHEN ua.activity_month =
      TO_CHAR(
        TO_DATE(c.cohort_month, 'YYYY-MM') + INTERVAL '1 month',
        'YYYY-MM'
      ) THEN 1 ELSE 0 END) AS m1,
    -- Was user active in Month 2 after signup?
    MAX(CASE WHEN ua.activity_month =
      TO_CHAR(
        TO_DATE(c.cohort_month, 'YYYY-MM') + INTERVAL '2 months',
        'YYYY-MM'
      ) THEN 1 ELSE 0 END) AS m2
  FROM cohorts c
  LEFT JOIN user_activity ua
    ON c.user_id = ua.user_id
  GROUP BY c.cohort_month, c.user_id
)
SELECT
  cohort_month,
  COUNT(*)                              AS cohort_size,
  SUM(m1)                               AS m1_retained,
  ROUND(SUM(m1) * 100.0 / COUNT(*), 1) AS m1_rate,
  SUM(m2)                               AS m2_retained,
  ROUND(SUM(m2) * 100.0 / COUNT(*), 1) AS m2_rate
FROM retention
GROUP BY cohort_month
HAVING
  SUM(m1) > 0 OR SUM(m2) > 0 -- only show cohorts with follow-up data
ORDER BY cohort_month;
