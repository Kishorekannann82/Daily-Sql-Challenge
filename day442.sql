/*
📌 Challenge 2.0 — Day 47: "Referral Program Multi-Level Attribution"

Scenario:
You're a Data Analyst at a fintech app with a referral program — existing users refer new users, who can themselves refer more users (a referral chain, up to 3 levels deep for bonus payout purposes). Growth wants to calculate the total downstream referrals each user is responsible for (direct + indirect, up to 3 levels), to pay out tiered bonuses.

Table: users

Column	Type
user_id	INT
referred_by	INT (NULL if not referred by anyone)
signup_date	DATE

Task: For each user, count how many users they're responsible for at Level 1 (direct referrals), Level 2 (referrals of their referrals), and Level 3 (one more level down). Output user_id, level_1_count, level_2_count, level_3_count, total_downstream.
*/
WITH RECURSIVE referral_chain AS (
    -- Anchor: every user paired with themselves at level 0
    SELECT 
        user_id AS referrer_id,
        user_id AS referred_user_id,
        0 AS level
    FROM users

    UNION ALL

    -- Recursive step: walk down to people referred by the current referred_user_id
    SELECT 
        rc.referrer_id,
        u.user_id AS referred_user_id,
        rc.level + 1
    FROM users u
    JOIN referral_chain rc 
        ON u.referred_by = rc.referred_user_id
    WHERE rc.level < 3   -- stop expanding beyond level 3
),
level_counts AS (
    SELECT 
        referrer_id,
        level,
        COUNT(*) AS user_count
    FROM referral_chain
    WHERE level BETWEEN 1 AND 3   -- exclude the self-pairing anchor (level 0)
    GROUP BY referrer_id, level
)
SELECT 
    u.user_id,
    COALESCE(SUM(CASE WHEN lc.level = 1 THEN lc.user_count END), 0) AS level_1_count,
    COALESCE(SUM(CASE WHEN lc.level = 2 THEN lc.user_count END), 0) AS level_2_count,
    COALESCE(SUM(CASE WHEN lc.level = 3 THEN lc.user_count END), 0) AS level_3_count,
    COALESCE(SUM(lc.user_count), 0) AS total_downstream
FROM users u
LEFT JOIN level_counts lc 
    ON u.user_id = lc.referrer_id
GROUP BY u.user_id
ORDER BY total_downstream DESC;
