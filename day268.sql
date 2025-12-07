/*
Weighted Attribution of Ad Clicks to Conversions
Scenario

You have ad interactions and final purchases:

clicks

click_id	user_id	click_time	campaign
1	101	2024-01-01 10:00:00	A
2	101	2024-01-02 12:00:00	B
3	101	2024-01-04 15:00:00	A
4	102	2024-01-10 08:00:00	C

conversions

conv_id	user_id	conv_time	revenue
501	101	2024-01-05 10:00:00	200
502	102	2024-01-10 09:00:00	100
❓ Business Rules

1️⃣ Only clicks within 7 days before a conversion are eligible
2️⃣ Credit decays as:

weight = 1 / (1 + days difference)


3️⃣ Campaign with highest weight gets full conversion value

🎯 Output

For each conversion:

conv_id

user_id

chosen_campaign

conversion_credit (full revenue assigned to that campaign)

✅ Expected SQL Answer (Postgres)
*/
WITH eligible_clicks AS (
    SELECT
        c.click_id,
        c.user_id,
        c.click_time,
        c.campaign,
        cv.conv_id,
        cv.conv_time,
        cv.revenue,
        DATE_PART('day', cv.conv_time - c.click_time) AS day_diff
    FROM clicks c
    JOIN conversions cv
        ON c.user_id = cv.user_id
       AND c.click_time <= cv.conv_time
       AND c.click_time >= cv.conv_time - INTERVAL '7 days'
),
weighted AS (
    SELECT
        click_id,
        user_id,
        campaign,
        conv_id,
        revenue,
        day_diff,
        1.0 / (1 + day_diff) AS weight
    FROM eligible_clicks
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY conv_id
            ORDER BY weight DESC
        ) AS rnk
    FROM weighted
)
SELECT
    conv_id,
    user_id,
    campaign AS chosen_campaign,
    revenue AS conversion_credit
FROM ranked
WHERE rnk = 1
ORDER BY conv_id;