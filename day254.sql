/*
Compute Rolling 7-Day & 30-Day Totals with Reset on Inactivity
Scenario:

You have a table of user logins:

logins

user_id	login_date
1	2024-01-01
1	2024-01-02
1	2024-01-10
1	2024-01-11
1	2024-02-25
2	2024-01-03
2	2024-01-04
2	2024-01-15
3	2024-02-01
3	2024-02-20
3	2024-02-21
Rules:

For each login event:

7-day rolling count: Count logins in the previous 7 days including today

30-day rolling count: Count logins in the previous 30 days including today

Streak reset rule:
If the gap between login_date and the previous login is > 14 days, the rolling windows MUST reset to 1 regardless of the window size.

❓Question:

Produce an output listing for each login:

user_id

login_date

previous_login_date

days_since_last_login

rolling_7_day_logins

rolling_30_day_logins

✅ Expected SQL Answer
*/

WITH ordered_logins AS (
    SELECT
        user_id,
        login_date,
        LAG(login_date) OVER (
            PARTITION BY user_id 
            ORDER BY login_date
        ) AS previous_login_date
    FROM logins
),
with_gap AS (
    SELECT
        user_id,
        login_date,
        previous_login_date,
        DATEDIFF(login_date, previous_login_date) AS days_since_last_login,
        CASE 
            WHEN previous_login_date IS NULL THEN 0
            WHEN DATEDIFF(login_date, previous_login_date) > 14 THEN 1
            ELSE 0
        END AS reset_flag
    FROM ordered_logins
),
with_groups AS (
    SELECT
        user_id,
        login_date,
        previous_login_date,
        days_since_last_login,
        SUM(reset_flag) OVER (
            PARTITION BY user_id 
            ORDER BY login_date
        ) AS reset_group
    FROM with_gap
),
final_calc AS (
    SELECT
        w1.*,
        (
            SELECT COUNT(*) 
            FROM with_groups w2
            WHERE w2.user_id = w1.user_id
              AND w2.reset_group = w1.reset_group
              AND w2.login_date BETWEEN DATE_SUB(w1.login_date, INTERVAL 7 DAY) AND w1.login_date
        ) AS rolling_7_day_logins,
        (
            SELECT COUNT(*) 
            FROM with_groups w3
            WHERE w3.user_id = w1.user_id
              AND w3.reset_group = w1.reset_group
              AND w3.login_date BETWEEN DATE_SUB(w1.login_date, INTERVAL 30 DAY) AND w1.login_date
        ) AS rolling_30_day_logins
    FROM with_groups w1
)
SELECT
    user_id,
    login_date,
    previous_login_date,
    days_since_last_login,
    rolling_7_day_logins,
    rolling_30_day_logins
FROM final_calc
ORDER BY user_id, login_date;