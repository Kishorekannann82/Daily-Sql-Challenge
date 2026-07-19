/*
Find the most and least efficient delivery routes
You work at a logistics company like Blue Dart. Each route makes multiple stops. Efficiency = total_packages_delivered / total_distance_km (packages per km). Find per route: total_stops, total_packages, total_distance_km, efficiency (rounded to 2 decimal places), and label as High (efficiency >= 2.0), Medium (>= 1.0), or Low (< 1.0). Order by efficiency descending.
Table: route_stops
stop_id	route_id	stop_number	packages_delivered	distance_from_prev_km
1	R01	1	15	5.0
2	R01	2	20	3.0
3	R01	3	10	2.0
4	R02	1	5	8.0
5	R02	2	3	7.0
6	R02	3	4	6.0
7	R03	1	25	4.0
8	R03	2	30	3.0
9	R03	3	20	5.5
10	R03	4	15	2.5
Expected output
route_id	total_stops	total_packages	total_distance_km	efficiency	efficiency_grade
R03	4	90	15.0	6.00	High
R01	3	45	10.0	4.50	High
R02	3	12	21.0	0.57	Low
R01 → 45 packages / 10km = 4.50 → High ✅
R02 → 12 packages / 21km = 0.57 → Low ❌ (long distances, few packages)
R03 → 90 packages / 15km = 6.00 → High ✅ (dense urban route, many stops)
*/
WITH route_stats AS (
  SELECT
    route_id,
    COUNT(*)                     AS total_stops,
    SUM(packages_delivered)     AS total_packages,
    SUM(distance_from_prev_km)  AS total_distance_km,
    ROUND(
      SUM(packages_delivered) * 1.0
      / NULLIF(SUM(distance_from_prev_km), 0)
    , 2)                          AS efficiency
  FROM route_stops
  GROUP BY route_id
)
SELECT
  route_id,
  total_stops,
  total_packages,
  total_distance_km,
  efficiency,
  CASE
    WHEN efficiency >= 2.0 THEN 'High'
    WHEN efficiency >= 1.0 THEN 'Medium'
    ELSE                        'Low'
  END                        AS efficiency_grade
FROM route_stats
ORDER BY efficiency DESC;
