/*
Ad Campaign Attribution With Lookback & Decay
Scenario

You track user clicks and purchases.

ad_clicks

click_id	user_id	click_time
1	101	2024-01-01 10:00:00
2	101	2024-01-03 09:00:00
3	102	2024-01-05 12:30:00

purchases

purchase_id	user_id	purchase_time	amount
10	101	2024-01-03 11:00:00	500
11	102	2024-01-08 10:00:00	300
Attribution Rules

Attribution window: within 48 hours before purchase

If multiple clicks qualify → later (most recent) click wins

Attribution decay multiplier:

decay = 1 - (hours_diff_from_click / 48)


Example: click 24 hours prior → decay = 1 - (24/48) = 0.5

Attribution score = amount * decay

❓Goal

Return:

purchase_id

user_id

purchase_time

attributed_click_id

hours_diff

attribution_score

✅ Expected SQL Answer (PostgreSQL)
*/
WITH matched AS (
    SELECT
        p.purchase_id,
        p.user_id,
        p.purchase_time,
        p.amount,
        c.click_id,
        EXTRACT(EPOCH FROM (p.purchase_time - c.click_time)) / 3600 AS hours_diff
    FROM purchases p
    JOIN ad_clicks c
      ON p.user_id = c.user_id
     AND c.click_time <= p.purchase_time
     AND p.purchase_time - c.click_time <= interval '48 hour'
),
ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY purchase_id
            ORDER BY hours_diff ASC  -- closest click wins
        ) AS rn
    FROM matched
)
SELECT
    purchase_id,
    user_id,
    purchase_time,
    click_id AS attributed_click_id,
    ROUND(hours_diff, 2) AS hours_diff,
    ROUND(amount * (1 - (hours_diff / 48)), 2) AS attribution_score
FROM ranked
WHERE rn = 1
ORDER BY purchase_id;