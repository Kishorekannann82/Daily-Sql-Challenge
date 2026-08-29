/*
Cumulative Distinct Count (Running Unique Visitors)"

Scenario:
You're a Data Analyst at a news website. Product wants a running total of unique visitors by day — i.e., "as of each day, how many distinct users have ever visited the site" (a classic growth chart metric). The catch: COUNT(DISTINCT ...) doesn't work directly inside a running window function in most SQL engines.

Table: visits

Column	Type
visit_id	INT
user_id	INT
visit_date	DATE

Task: Output visit_date, daily_unique_visitors, cumulative_unique_visitors — where cumulative counts each user only once, on the day they first appeared, even if they visit again later.
*/
WITH first_visit AS (
    SELECT 
        user_id,
        MIN(visit_date) AS first_visit_date
    FROM visits
    GROUP BY user_id
),
daily_new_users AS (
    SELECT 
        first_visit_date AS visit_date,
        COUNT(*) AS new_users
    FROM first_visit
    GROUP BY first_visit_date
),
daily_totals AS (
    SELECT 
        v.visit_date,
        COUNT(DISTINCT v.user_id) AS daily_unique_visitors
    FROM visits v
    GROUP BY v.visit_date
)
SELECT 
    dt.visit_date,
    dt.daily_unique_visitors,
    SUM(COALESCE(dnu.new_users, 0)) OVER (
        ORDER BY dt.visit_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_unique_visitors
FROM daily_totals dt
LEFT JOIN daily_new_users dnu 
    ON dt.visit_date = dnu.visit_date
ORDER BY dt.visit_date;
