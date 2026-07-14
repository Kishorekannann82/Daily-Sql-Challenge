/*
Build a complete platform health dashboard — one query
You're a senior data analyst at an e-commerce platform. The CEO wants a single dashboard query showing per category:

→ total_orders and total_revenue
→ avg_order_value (rounded to 0 decimal)
→ return_rate % (rounded to 1 decimal)
→ unique_customers
→ revenue_rank — rank by revenue across categories
→ revenue_share % of total platform revenue (rounded to 1 decimal)
→ health — Star (rank=1), Growing (rank 2–3), Watch (return_rate > 20%), else Stable
Table: orders
order_id	customer_id	category	amount	is_returned
O01	C01	Electronics	5000	0
O02	C02	Electronics	3000	1
O03	C01	Electronics	4000	0
O04	C03	Fashion	1200	1
O05	C04	Fashion	800	1
O06	C02	Fashion	1500	0
O07	C05	Grocery	600	0
O08	C01	Grocery	450	0
O09	C03	Grocery	700	0
O10	C06	Books	400	0
O11	C07	Books	350	1
O12	C06	Books	300	0
Expected output
category	total_orders	revenue	aov	return_rate	unique_customers	rev_rank	rev_share	health
Electronics	3	12000	4000	33.3	2	1	62.2	Star
Fashion	3	3500	1167	66.7	3	2	18.1	Watch
Grocery	3	1750	583	0.0	3	3	9.1	Growing
Books	3	1050	350	33.3	2	4	5.4	Watch
Electronics → rank 1 → Star 🌟 (despite 33% return rate, rank overrides)
Fashion → rank 2 BUT return_rate 66.7% > 20% → Watch ⚠️ (Watch takes priority)
Grocery → rank 3 → Growing 📈 (0% returns, healthy)
Books → rank 4 AND return_rate 33.3% > 20% → Watch ⚠️
Total revenue = 12000+3500+1750+1050 = 19300
*/
WITH cat_stats AS (
  SELECT
    category,
    COUNT(*)                                    AS total_orders,
    SUM(amount)                                 AS revenue,
    ROUND(AVG(amount))                          AS aov,
    ROUND(SUM(is_returned)*100.0/COUNT(*), 1)  AS return_rate,
    COUNT(DISTINCT customer_id)                 AS unique_customers
  FROM orders
  GROUP BY category
),
with_rank AS (
  SELECT
    *,
    DENSE_RANK() OVER (
      ORDER BY revenue DESC
    )                                            AS rev_rank,
    ROUND(revenue * 100.0 /
      SUM(revenue) OVER ()
    , 1)                                         AS rev_share
  FROM cat_stats
)
SELECT
  category,
  total_orders,
  revenue,
  aov,
  return_rate,
  unique_customers,
  rev_rank,
  rev_share,
  CASE
    WHEN rev_rank = 1                  THEN 'Star'
    WHEN return_rate > 20              THEN 'Watch'
    WHEN rev_rank BETWEEN 2 AND 3    THEN 'Growing'
    ELSE                                    'Stable'
  END                                  AS health
FROM with_rank
ORDER BY rev_rank;
