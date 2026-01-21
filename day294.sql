/*
Multi-Touch Funnel Revenue Attribution (Linear Model)
Scenario

Users interact with multiple marketing touchpoints before converting.
You want to attribute conversion revenue across all touchpoints in the funnel using a linear attribution model.

touchpoints
user_id	touch_time	channel
101	2024-01-01 09:00	Email
101	2024-01-02 10:00	Ads
101	2024-01-03 11:00	Search
102	2024-01-05 12:00	Ads
102	2024-01-06 13:00	Email
103	2024-01-07 14:00	Search
conversions
user_id	conversion_time	revenue
101	2024-01-04 12:00	300
102	2024-01-07 15:00	200

📌 Rules

Only touchpoints before conversion count

Revenue is evenly split across all qualifying touchpoints

Non-converting users are ignored

❓ Goal

Return revenue attributed per channel.

Output:

channel

attributed_revenue

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH eligible AS (
    SELECT
        t.user_id,
        t.channel,
        c.revenue,
        COUNT(*) OVER (
            PARTITION BY t.user_id
        ) AS touch_count
    FROM touchpoints t
    JOIN conversions c
      ON t.user_id = c.user_id
     AND t.touch_time < c.conversion_time
),
distributed AS (
    SELECT
        channel,
        revenue * 1.0 / touch_count AS attributed_revenue
    FROM eligible
)
SELECT
    channel,
    ROUND(SUM(attributed_revenue), 2) AS attributed_revenue
FROM distributed
GROUP BY channel
ORDER BY attributed_revenue DESC;
