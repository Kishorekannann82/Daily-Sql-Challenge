/*
A/B Test Analysis (Conversion Rate & Lift)
Scenario

You ran an A/B experiment on a checkout page.

ab_events

user_id	variant	event_name	event_time
101	A	VIEW	2024-01-01
101	A	PURCHASE	2024-01-01
102	A	VIEW	2024-01-01
103	A	VIEW	2024-01-02
103	A	PURCHASE	2024-01-02
201	B	VIEW	2024-01-01
202	B	VIEW	2024-01-01
202	B	PURCHASE	2024-01-01
203	B	VIEW	2024-01-02
204	B	VIEW	2024-01-02
204	B	PURCHASE	2024-01-02

📌 Definitions

Visitor → user with VIEW

Converter → user with PURCHASE

Conversion Rate = converters / visitors

Lift (%) = (CR_B − CR_A) / CR_A × 100

❓ Goal

Compute, per variant:

visitors

converters

conversion_rate

Then compute:

lift_percentage of B vs A

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
WITH visitors AS (
    SELECT DISTINCT user_id, variant
    FROM ab_events
    WHERE event_name = 'VIEW'
),
converters AS (
    SELECT DISTINCT user_id, variant
    FROM ab_events
    WHERE event_name = 'PURCHASE'
),
metrics AS (
    SELECT
        v.variant,
        COUNT(DISTINCT v.user_id) AS visitors,
        COUNT(DISTINCT c.user_id) AS converters
    FROM visitors v
    LEFT JOIN converters c
      ON v.user_id = c.user_id
     AND v.variant = c.variant
    GROUP BY v.variant
),
rates AS (
    SELECT
        variant,
        visitors,
        converters,
        converters * 1.0 / visitors AS conversion_rate
    FROM metrics
)
SELECT
    r.variant,
    r.visitors,
    r.converters,
    ROUND(r.conversion_rate, 4) AS conversion_rate,
    CASE
        WHEN r.variant = 'B' THEN
            ROUND(
                (r.conversion_rate -
                 (SELECT conversion_rate FROM rates WHERE variant = 'A'))
                /
                (SELECT conversion_rate FROM rates WHERE variant = 'A')
                * 100, 2
            )
        ELSE NULL
    END AS lift_percentage_vs_A
FROM rates r
ORDER BY variant;