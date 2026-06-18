/*
Find peak ordering hours per restaurant
You work at Swiggy. The restaurant operations team wants to know the top 2 peak hours (by order count) for each restaurant — so restaurants can staff up at the right times. Return restaurant_name, order_hour, order_count, and rank.
Table: restaurants
restaurant_id	restaurant_name
R01	Biryani Blues
R02	Pizza Palace
R03	Dosa Delight
Table: orders
order_id	restaurant_id	ordered_at
1	R01	2024-05-01 12:10:00
2	R01	2024-05-01 12:45:00
3	R01	2024-05-01 13:05:00
4	R01	2024-05-01 20:15:00
5	R01	2024-05-01 20:50:00
6	R01	2024-05-01 20:55:00
7	R01	2024-05-01 21:10:00
8	R02	2024-05-01 13:00:00
9	R02	2024-05-01 13:30:00
10	R02	2024-05-01 19:00:00
11	R02	2024-05-01 19:45:00
12	R02	2024-05-01 19:50:00
13	R03	2024-05-01 08:00:00
14	R03	2024-05-01 08:30:00
15	R03	2024-05-01 08:55:00
16	R03	2024-05-01 12:00:00
17	R03	2024-05-01 12:20:00
Expected output
restaurant_name	order_hour	order_count	rank
Biryani Blues	20	3	1
Biryani Blues	12	2	2
Pizza Palace	19	3	1
Pizza Palace	13	2	2
Dosa Delight	8	3	1
Dosa Delight	12	2	2
Biryani Blues → 20:00 has 3 orders (20:15, 20:50, 20:55) 🏆 rank 1
→ 12:00 has 2 orders (12:10, 12:45) rank 2 | 13:00 has 1 → rank 3 excluded
Pizza Palace → 19:00 has 3 orders rank 1 | 13:00 has 2 orders rank 2
Dosa Delight → 08:00 has 3 orders rank 1 | 12:00 has 2 orders rank 2
*/
WITH hourly AS (
  SELECT
    o.restaurant_id,
    EXTRACT(HOUR FROM o.ordered_at) AS order_hour,
    COUNT(*)                          AS order_count
  FROM orders o
  GROUP BY o.restaurant_id,
           EXTRACT(HOUR FROM o.ordered_at)
),
ranked AS (
  SELECT
    restaurant_id,
    order_hour,
    order_count,
    DENSE_RANK() OVER (
      PARTITION BY restaurant_id
      ORDER BY order_count DESC
    ) AS rnk
  FROM hourly
)
SELECT
  r.restaurant_name,
  rk.order_hour,
  rk.order_count,
  rk.rnk AS rank
FROM ranked rk
JOIN restaurants r
  ON rk.restaurant_id = r.restaurant_id
WHERE rk.rnk <= 2
ORDER BY r.restaurant_name, rk.rnk;
