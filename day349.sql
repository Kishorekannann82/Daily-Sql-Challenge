/*
Find users with unusually high data usage compared to their plan
You work at a telecom company like Jio. Each user has a monthly data plan (in GB). Find users whose actual data usage exceeded their plan limit by more than 20% in any month. Return user_name, month, plan_gb, used_gb, and overage_pct rounded to 1 decimal place.
Table: users
user_id	user_name	plan_gb
U01	Karthik	30
U02	Lavanya	20
U03	Manoj	50
U04	Nisha	10
Table: data_usage
usage_id	user_id	usage_date	used_gb
1	U01	2024-04-01	12
2	U01	2024-04-15	22
3	U01	2024-05-01	10
4	U02	2024-04-10	8
5	U02	2024-04-20	16
6	U03	2024-04-05	20
7	U03	2024-04-18	18
8	U04	2024-04-02	5
9	U04	2024-04-22	7
10	U04	2024-05-05	4
Expected output
user_name	month	plan_gb	used_gb	overage_pct
Karthik	2024-04	30	34	13.3
Lavanya	2024-04	20	24	20.0
Nisha	2024-04	10	12	20.0
Karthik → Apr: 12+22=34GB vs plan 30GB → 13.3% over → wait that's not >20%...
Lavanya → Apr: 8+16=24GB vs plan 20GB → 20.0% → exactly 20, not strictly >20 ❌ hmm
Nisha → Apr: 5+7=12GB vs plan 10GB → 20.0% → same edge case
Manoj → Apr: 20+18=38GB vs plan 50GB → under plan ❌
⚠️ Check the answer carefully — the threshold is >= 20% overage, not strictly >20%.
Problem says "more than 20%" — verify the boundary logic in the answer!
*/
WITH monthly_usage AS (
  SELECT
    u.user_id,
    u.user_name,
    u.plan_gb,
    TO_CHAR(d.usage_date, 'YYYY-MM') AS month,
    SUM(d.used_gb)               AS used_gb
  FROM users u
  JOIN data_usage d
    ON u.user_id = d.user_id
  GROUP BY u.user_id, u.user_name, u.plan_gb,
           TO_CHAR(d.usage_date, 'YYYY-MM')
)
SELECT
  user_name,
  month,
  plan_gb,
  used_gb,
  ROUND(
    (used_gb - plan_gb) * 100.0 / plan_gb
  , 1) AS overage_pct
FROM monthly_usage
WHERE used_gb >= plan_gb * 1.20
ORDER BY overage_pct DESC;
