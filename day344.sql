/*
Find top referrers whose referred users also referred someone
You work at a fintech app like CRED or Groww. The growth team runs a 2-level referral program — User A refers User B (level 1), and User B refers User C (level 2). Find all level-1 referrers who have at least one level-2 referral (i.e. someone they referred also referred someone else). Return referrer_name, level1_referrals, and level2_referrals.
Table: users
user_id	name	referred_by
U01	Anand	NULL
U02	Bala	U01
U03	Chitra	U01
U04	Divya	U02
U05	Elan	U02
U06	Fiona	U03
U07	Ganesh	U04
U08	Hari	NULL
U09	Indira	U08
Expected output
referrer_name	level1_referrals	level2_referrals
Anand	2	3
Bala	2	1
Anand (U01) → referred Bala(U02), Chitra(U03) = 2 level-1
→ Bala referred Divya,Elan; Chitra referred Fiona = 3 level-2 ✅
Bala (U02) → referred Divya(U04), Elan(U05) = 2 level-1
→ Divya referred Ganesh = 1 level-2 ✅
Chitra (U03) → referred Fiona(U06) = 1 level-1
→ Fiona referred nobody = 0 level-2 ❌ excluded
Hari (U08) → referred Indira(U09), Indira referred nobody = 0 level-2 ❌ excluded
*/
WITH level1 AS (
  -- Direct referrals: who did the referrer bring in?
  SELECT
    r.user_id   AS referrer_id,
    r.name      AS referrer_name,
    l1.user_id  AS l1_user_id
  FROM users r
  JOIN users l1
    ON l1.referred_by = r.user_id
),
level2 AS (
  -- Indirect referrals: who did the level-1 users bring in?
  SELECT
    l1.referrer_id,
    l2.user_id AS l2_user_id
  FROM level1 l1
  JOIN users l2
    ON l2.referred_by = l1.l1_user_id
)
SELECT
  l1.referrer_name,
  COUNT(DISTINCT l1.l1_user_id)  AS level1_referrals,
  COUNT(DISTINCT l2.l2_user_id)  AS level2_referrals
FROM level1 l1
JOIN level2 l2
  ON l1.referrer_id = l2.referrer_id
GROUP BY l1.referrer_id, l1.referrer_name
HAVING COUNT(DISTINCT l2.l2_user_id) >= 1
ORDER BY level2_referrals DESC;
