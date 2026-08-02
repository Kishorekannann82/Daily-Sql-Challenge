/*
Day 63
Intermediate
Food Delivery / Swiggy Zomato
Restaurant Revenue Trend — MoM with Status
Restaurants whose revenue dropped two months in a row
You work at Swiggy's restaurant analytics team. Find restaurants that had a revenue decline for two consecutive months — these are at risk of churning off the platform. Return restaurant_name, month1, month1_revenue, month2, month2_revenue, month3, month3_revenue.
Table: monthly_revenue
restaurant_name	month	revenue
Biryani Blues	2024-01	85000
Biryani Blues	2024-02	92000
Biryani Blues	2024-03	88000
Pizza Palace	2024-01	60000
Pizza Palace	2024-02	55000
Pizza Palace	2024-03	48000
Dosa Delight	2024-01	40000
Dosa Delight	2024-02	38000
Dosa Delight	2024-03	42000
Noodle House	2024-01	70000
Noodle House	2024-02	65000
Noodle House	2024-03	58000
Expected output
restaurant_name	month1	m1_rev	month2	m2_rev	month3	m3_rev
Pizza Palace	2024-01	60000	2024-02	55000	2024-03	48000
Noodle House	2024-01	70000	2024-02	65000	2024-03	58000
Biryani Blues → 85k→92k→88k: went UP then down → no consecutive 2-month drop ❌
Pizza Palace → 60k→55k→48k: dropped both months ✅ at risk!
Dosa Delight → 40k→38k→42k: dropped then recovered ❌
Noodle House → 70k→65k→58k: dropped both months ✅ at risk!
*/
WITH lagged AS (
  SELECT
    restaurant_name,
    month                                          AS month3,
    revenue                                        AS m3_rev,
    LAG(month,   1) OVER (
      PARTITION BY restaurant_name ORDER BY month
    )                                              AS month2,
    LAG(revenue, 1) OVER (
      PARTITION BY restaurant_name ORDER BY month
    )                                              AS m2_rev,
    LAG(month,   2) OVER (
      PARTITION BY restaurant_name ORDER BY month
    )                                              AS month1,
    LAG(revenue, 2) OVER (
      PARTITION BY restaurant_name ORDER BY month
    )                                              AS m1_rev
  FROM monthly_revenue
)
SELECT
  restaurant_name,
  month1, m1_rev,
  month2, m2_rev,
  month3, m3_rev
FROM lagged
WHERE
  m1_rev IS NOT NULL
  AND m2_rev IS NOT NULL
  AND m3_rev < m2_rev
  AND m2_rev < m1_rev
ORDER BY m3_rev DESC;
