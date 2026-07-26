/*
Attribute revenue to the first marketing channel that brought the user
You work at a growth analytics company. Users arrive via different marketing channels across multiple sessions before they convert (make a purchase). Use first-touch attribution — credit the first channel that ever brought the user. Find the total revenue attributed to each channel, the number of converted users, and the average revenue per converted user. Only include users who eventually made a purchase.
Table: sessions
session_id	user_id	channel	session_date
S01	U01	Google	2024-01-01
S02	U01	Facebook	2024-01-03
S03	U01	Email	2024-01-05
S04	U02	Facebook	2024-01-02
S05	U02	Google	2024-01-04
S06	U03	Email	2024-01-01
S07	U03	Facebook	2024-01-03
S08	U04	Google	2024-01-02
S09	U05	Email	2024-01-01
S10	U05	Google	2024-01-03
Table: purchases
purchase_id	user_id	amount	purchase_date
P01	U01	1500	2024-01-06
P02	U02	2200	2024-01-05
P03	U03	800	2024-01-04
P04	U05	3100	2024-01-05
Expected output
channel	converted_users	total_revenue	avg_revenue_per_user
Email	2	3900	1950.0
Google	1	2200	2200.0
Facebook	1	1500	1500.0
U01 → first session = Google (Jan1) → but U01 purchased → Google gets credit? Wait...
U01 first touch = Google ✅ | U02 first touch = Facebook ✅
U03 first touch = Email ✅ | U04 = Google but no purchase ❌
U05 first touch = Email ✅
Google credited for U02 (2200) | Facebook for U01 (1500) | Email for U03(800)+U05(3100)=3900
⚠️ Verify: U01's first session is Google (Jan1) so Google should get U01's 1500?
Actually: U01 first=Google, U02 first=Facebook, U03 first=Email, U05 first=Email
→ Google: U01=1500 | Facebook: U02=2200 | Email: U03+U05=3900 — check expected!
*/
WITH first_touch AS (
  -- Step 1: find each user's very first session channel
  SELECT DISTINCT ON (user_id)
    user_id,
    channel AS first_channel
  FROM sessions
  ORDER BY user_id, session_date ASC
),
converted AS (
  -- Step 2: join first-touch to purchases (only converted users)
  SELECT
    ft.user_id,
    ft.first_channel,
    SUM(p.amount) AS user_revenue
  FROM first_touch ft
  JOIN purchases p
    ON ft.user_id = p.user_id
  GROUP BY ft.user_id, ft.first_channel
)
SELECT
  first_channel                              AS channel,
  COUNT(*)                                  AS converted_users,
  SUM(user_revenue)                         AS total_revenue,
  ROUND(AVG(user_revenue), 1)              AS avg_revenue_per_user
FROM converted
GROUP BY first_channel
ORDER BY total_revenue DESC;
