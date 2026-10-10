/*
📌 Challenge 2.0 — Day 57: “Customer Journey: First Touch to Conversion Within a Window”

Scenario:
You’re a Data Analyst at a B2B SaaS company. Marketing wants to know what share of leads convert to a paid plan within 30 days of their first touch, broken down by the lead source (organic, paid ads, referral, etc.). Leads that haven’t had 30 full days to convert yet must not drag the numbers down.

Table: leads

Column	Type
lead_id	INT
lead_source	VARCHAR
first_touch_date	DATE

Table: conversions

Column	Type
conversion_id	INT
lead_id	INT
conversion_date	DATE

Task: For each lead_source, output eligible_leads, converted_within_30d, conversion_rate_30d. Only include leads whose first_touch_date is at least 30 days ago (fully matured), and count a lead as converted only if its earliest conversion happened within 30 days of first touch.
*/
WITH first_conversion AS (
    SELECT 
        lead_id,
        MIN(conversion_date) AS first_conversion_date
    FROM conversions
    GROUP BY lead_id
),
matured_leads AS (
    SELECT 
        l.lead_id,
        l.lead_source,
        l.first_touch_date,
        fc.first_conversion_date
    FROM leads l
    LEFT JOIN first_conversion fc 
        ON l.lead_id = fc.lead_id
    WHERE l.first_touch_date <= CURRENT_DATE - INTERVAL '30 days'   -- only fully matured leads
)
SELECT 
    lead_source,
    COUNT(*) AS eligible_leads,
    SUM(
        CASE 
            WHEN first_conversion_date IS NOT NULL
             AND first_conversion_date >= first_touch_date
             AND first_conversion_date <= first_touch_date + INTERVAL '30 days'
            THEN 1 ELSE 0 
        END
    ) AS converted_within_30d,
    ROUND(
        SUM(
            CASE 
                WHEN first_conversion_date IS NOT NULL
                 AND first_conversion_date >= first_touch_date
                 AND first_conversion_date <= first_touch_date + INTERVAL '30 days'
                THEN 1 ELSE 0 
            END
        ) * 100.0 / COUNT(*), 2
    ) AS conversion_rate_30d
FROM matured_leads
GROUP BY lead_source
ORDER BY conversion_rate_30d DESC;
