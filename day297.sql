/*
Time-Decay Multi-Touch Attribution
Scenario

Users interact with marketing channels before converting.
More recent touchpoints should get more credit.

touchpoints
user_id	touch_time	channel
101	2024-01-01 09:00	Email
101	2024-01-02 10:00	Ads
101	2024-01-03 11:00	Search
102	2024-01-05 12:00	Ads
102	2024-01-06 13:00	Email
conversions
user_id	conversion_time	revenue
101	2024-01-04 12:00	300
102	2024-01-07 15:00	200

📌 Time-Decay Rule
Weight per touchpoint:

weight = 1 / (1 + days_before_conversion)


Revenue is split proportionally by weights.

❓ Goal

Return revenue attributed per channel.

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH eligible AS (
    SELECT
        t.user_id,
        t.channel,
        c.revenue,
        DATEDIFF(c.conversion_time, t.touch_time) AS days_before,
        1.0 / (1 + DATEDIFF(c.conversion_time, t.touch_time)) AS weight
    FROM touchpoints t
    JOIN conversions c
      ON t.user_id = c.user_id
     AND t.touch_time < c.conversion_time
),
normalized AS (
    SELECT
        user_id,
        channel,
        revenue,
        weight,
        weight / SUM(weight) OVER (PARTITION BY user_id) AS norm_weight
    FROM eligible
),
distributed AS (
    SELECT
        channel,
        revenue * norm_weight AS attributed_revenue
    FROM normalized
)
SELECT
    channel,
    ROUND(SUM(attributed_revenue), 2) AS attributed_revenue
FROM distributed
GROUP BY channel
ORDER BY attributed_revenue DESC;
