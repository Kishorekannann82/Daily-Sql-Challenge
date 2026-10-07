/*
📌 Challenge 2.0 — Day 54: "Content Moderation — Repeat Offender Escalation Scoring"

Scenario:
You're a Data Analyst at a social platform's trust & safety team. Moderation wants an escalating severity score per user: each violation adds points based on severity (minor=1, moderate=3, severe=10), but violations decay — any violation older than 90 days counts for half its original weight (to avoid permanently penalizing someone for a single old mistake while still tracking recent patterns). Flag users with a current score ≥ 15 for manual review.

Table: violations

Column	Type
violation_id	INT
user_id	INT
severity	VARCHAR
violation_date	DATE

Task: Calculate each user's current weighted score as of CURRENT_DATE, applying the decay rule, and flag for review. Output user_id, total_violations, current_score, flag_for_review.
*/
WITH severity_points AS (
    SELECT 
        v.user_id,
        v.violation_id,
        v.violation_date,
        CASE v.severity
            WHEN 'minor' THEN 1
            WHEN 'moderate' THEN 3
            WHEN 'severe' THEN 10
        END AS base_points,
        CURRENT_DATE - v.violation_date AS days_old
    FROM violations v
),
weighted AS (
    SELECT 
        user_id,
        violation_id,
        CASE 
            WHEN days_old > 90 THEN base_points * 0.5   -- decayed weight for old violations
            ELSE base_points * 1.0                       -- full weight for recent ones
        END AS weighted_points
    FROM severity_points
),
user_scores AS (
    SELECT 
        user_id,
        COUNT(*) AS total_violations,
        SUM(weighted_points) AS current_score
    FROM weighted
    GROUP BY user_id
)
SELECT 
    user_id,
    total_violations,
    ROUND(current_score, 2) AS current_score,
    CASE 
        WHEN current_score >= 15 THEN 'YES'
        ELSE 'NO'
    END AS flag_for_review
FROM user_scores
ORDER BY current_score DESC;
