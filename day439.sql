/*
📌 Challenge 2.0 — Day 44: "Subscription Plan Upgrade/Downgrade Path Tracking"

Scenario:
You're a Data Analyst at a SaaS company with tiered plans (Free → Basic → Pro → Enterprise). Product wants to track plan change history per customer — specifically, classify each change event as an 'Upgrade', 'Downgrade', or 'Lateral' (rare, e.g., a renamed equivalent-tier plan), and find customers who downgraded after upgrading (a churn-risk red flag) within the same billing year.

Table: plan_changes

Column	Type
change_id	INT
customer_id	INT
old_plan	VARCHAR
new_plan	VARCHAR
change_date	DATE

Table: plan_tiers

Column	Type
plan_name	VARCHAR
tier_level	INT

Task: Classify every change event, then find customers who had an Upgrade followed later by a Downgrade within the same calendar year. Output customer_id, upgrade_date, upgrade_to, downgrade_date, downgrade_to.
*/
WITH classified AS (
    SELECT 
        pc.customer_id,
        pc.change_date,
        pc.old_plan,
        pc.new_plan,
        pt_old.tier_level AS old_tier,
        pt_new.tier_level AS new_tier,
        CASE 
            WHEN pt_new.tier_level > pt_old.tier_level THEN 'Upgrade'
            WHEN pt_new.tier_level < pt_old.tier_level THEN 'Downgrade'
            ELSE 'Lateral'
        END AS change_type,
        EXTRACT(YEAR FROM pc.change_date) AS change_year
    FROM plan_changes pc
    JOIN plan_tiers pt_old ON pc.old_plan = pt_old.plan_name
    JOIN plan_tiers pt_new ON pc.new_plan = pt_new.plan_name
),
upgrades AS (
    SELECT customer_id, change_date AS upgrade_date, new_plan AS upgrade_to, change_year
    FROM classified
    WHERE change_type = 'Upgrade'
),
downgrades AS (
    SELECT customer_id, change_date AS downgrade_date, new_plan AS downgrade_to, change_year
    FROM classified
    WHERE change_type = 'Downgrade'
),
paired AS (
    SELECT 
        u.customer_id,
        u.upgrade_date,
        u.upgrade_to,
        d.downgrade_date,
        d.downgrade_to,
        ROW_NUMBER() OVER (
            PARTITION BY u.customer_id, u.upgrade_date 
            ORDER BY d.downgrade_date ASC
        ) AS rn
    FROM upgrades u
    JOIN downgrades d 
        ON u.customer_id = d.customer_id
        AND u.change_year = d.change_year
        AND d.downgrade_date > u.upgrade_date   -- downgrade must come AFTER the upgrade
)
SELECT 
    customer_id,
    upgrade_date,
    upgrade_to,
    downgrade_date,
    downgrade_to
FROM paired
WHERE rn = 1   -- earliest downgrade following each upgrade
ORDER BY customer_id, upgrade_date;
