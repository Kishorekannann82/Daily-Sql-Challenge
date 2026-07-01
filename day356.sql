/*
Build a complete seller performance scorecard
You work at Flipkart's seller analytics team. Build a seller scorecard that shows for each seller:

→ total_orders — how many orders fulfilled
→ total_revenue — total GMV
→ avg_rating — average customer rating (rounded to 1 decimal)
→ return_rate — % of orders returned (rounded to 1 decimal)
→ on_time_rate — % of orders delivered on time (rounded to 1 decimal)
→ seller_grade — Platinum (avg_rating>=4.5 AND return_rate<5 AND on_time_rate>=95), Gold (avg_rating>=4.0 AND return_rate<10 AND on_time_rate>=90), Silver otherwise
Table: sellers
seller_id	seller_name
S01	TechZone
S02	FashionHub
S03	GadgetKing
Table: orders
order_id	seller_id	amount	rating	is_returned	is_on_time
O01	S01	1200	5	0	1
O02	S01	800	4	0	1
O03	S01	950	5	0	1
O04	S01	500	4	0	0
O05	S02	2200	3	1	1
O06	S02	1800	4	0	1
O07	S02	900	2	1	0
O08	S02	600	4	0	1
O09	S03	3500	5	0	1
O10	S03	2800	5	0	1
O11	S03	1900	4	0	1
Expected output
seller_name	total_orders	total_revenue	avg_rating	return_rate	on_time_rate	seller_grade
GadgetKing	3	8200	4.7	0.0	100.0	Platinum
TechZone	4	3450	4.5	0.0	75.0	Gold
FashionHub	4	5500	3.3	50.0	75.0	Silver
GadgetKing → rating 4.7, 0% returns, 100% on time → Platinum 🏆
TechZone → rating 4.5, 0% returns, 75% on time (1 late) → on_time_rate <95 → Gold 🥇
FashionHub → rating 3.3, 50% returns → Silver 🥈
*/
WITH scorecard AS (
  SELECT
    s.seller_name,
    COUNT(o.order_id)                        AS total_orders,
    SUM(o.amount)                            AS total_revenue,
    ROUND(AVG(o.rating), 1)                 AS avg_rating,
    ROUND(SUM(o.is_returned) * 100.0
          / COUNT(*), 1)                     AS return_rate,
    ROUND(SUM(o.is_on_time) * 100.0
          / COUNT(*), 1)                     AS on_time_rate
  FROM sellers s
  JOIN orders o
    ON s.seller_id = o.seller_id
  GROUP BY s.seller_id, s.seller_name
)
SELECT
  seller_name,
  total_orders,
  total_revenue,
  avg_rating,
  return_rate,
  on_time_rate,
  CASE
    WHEN avg_rating  >= 4.5
     AND return_rate  <  5
     AND on_time_rate >= 95 THEN 'Platinum'
    WHEN avg_rating  >= 4.0
     AND return_rate  < 10
     AND on_time_rate >= 90 THEN 'Gold'
    ELSE                          'Silver'
  END                              AS seller_grade
FROM scorecard
ORDER BY total_revenue DESC;
