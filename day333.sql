/*
Detect users who downgraded their subscription plan
You work at a SaaS company like Spotify or Hotstar. Users can switch between plans — Free, Basic, Premium. Find all users who downgraded their plan at any point (moved to a lower tier). Return user_id, downgraded_from, downgraded_to, and changed_on.
Table: plan_changes
change_id	user_id	plan	changed_on
1	U01	Free	2024-01-01
2	U01	Basic	2024-02-01
3	U01	Premium	2024-03-01
4	U01	Basic	2024-05-01
5	U02	Premium	2024-01-15
6	U02	Free	2024-03-15
7	U03	Basic	2024-02-10
8	U03	Premium	2024-04-10
9	U04	Premium	2024-01-20
10	U04	Premium	2024-06-20
Expected output
user_id	downgraded_from	downgraded_to	changed_on
U01	Premium	Basic	2024-05-01
U02	Premium	Free	2024-03-15
U01 → Free→Basic→Premium→Basic : Premium to Basic = downgrade ❌✅
U02 → Premium→Free : clear downgrade ✅
U03 → Basic→Premium : only upgrade, never downgraded ❌
U04 → Premium→Premium : same plan, no change ❌

Plan rank: Free=1, Basic=2, Premium=3
*/
WITH ranked_plans AS (
  SELECT
    user_id,
    plan,
    changed_on,
    CASE plan
      WHEN 'Free'    THEN 1
      WHEN 'Basic'   THEN 2
      WHEN 'Premium' THEN 3
    END AS plan_rank
  FROM plan_changes
),
with_prev AS (
  SELECT
    user_id,
    plan                                        AS current_plan,
    changed_on,
    plan_rank,
    LAG(plan)      OVER (
      PARTITION BY user_id ORDER BY changed_on
    )                                           AS prev_plan,
    LAG(plan_rank) OVER (
      PARTITION BY user_id ORDER BY changed_on
    )                                           AS prev_rank
  FROM ranked_plans
)
SELECT
  user_id,
  prev_plan    AS downgraded_from,
  current_plan AS downgraded_to,
  changed_on
FROM with_prev
WHERE plan_rank < prev_rank
ORDER BY user_id, changed_on;