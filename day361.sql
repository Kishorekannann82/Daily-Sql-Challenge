/*
Identify drivers who earn more during surge vs non-surge hours
You work at Uber. Surge hours are 7–10 AM and 5–9 PM (17:00–21:00). For each driver find their surge earnings, non-surge earnings, total earnings, and surge % (rounded to 1 decimal). Only return drivers where surge earnings are more than 60% of their total — these are truly surge-dependent drivers.
Table: rides
ride_id	driver_id	pickup_time	fare
1	D01	2024-06-01 08:10:00	250
2	D01	2024-06-01 09:30:00	300
3	D01	2024-06-01 13:00:00	150
4	D01	2024-06-01 18:30:00	400
5	D01	2024-06-01 19:45:00	350
6	D02	2024-06-01 07:30:00	200
7	D02	2024-06-01 11:00:00	300
8	D02	2024-06-01 14:00:00	250
9	D02	2024-06-01 16:00:00	280
10	D03	2024-06-01 08:00:00	500
11	D03	2024-06-01 18:00:00	600
12	D03	2024-06-01 20:30:00	450
Expected output
driver_id	surge_earnings	non_surge_earnings	total_earnings	surge_pct
D01	1300	150	1450	89.7
D03	1550	0	1550	100.0
Surge hours: 7–10 AM (hour 7,8,9) and 5–9 PM (hour 17,18,19,20)
D01 → surge: 08:10(250)+09:30(300)+18:30(400)+19:45(350)=1300 | non: 13:00(150) → 89.7% ✅
D02 → surge: 07:30(200) | non: 11:00(300)+14:00(250)+16:00(280)=830 → 19.4% ❌
D03 → surge: 08:00(500)+18:00(600)+20:30(450)=1550 | non: 0 → 100% ✅

Answer
*/
WITH tagged AS (
  SELECT
    driver_id,
    fare,
    EXTRACT(HOUR FROM pickup_time) AS hr,
    CASE
      WHEN EXTRACT(HOUR FROM pickup_time)
             BETWEEN 7 AND 9
        OR  EXTRACT(HOUR FROM pickup_time)
             BETWEEN 17 AND 20
      THEN 1 ELSE 0
    END AS is_surge
  FROM rides
),
summary AS (
  SELECT
    driver_id,
    SUM(CASE WHEN is_surge = 1 THEN fare ELSE 0 END) AS surge_earnings,
    SUM(CASE WHEN is_surge = 0 THEN fare ELSE 0 END) AS non_surge_earnings,
    SUM(fare)                                         AS total_earnings
  FROM tagged
  GROUP BY driver_id
)
SELECT
  driver_id,
  surge_earnings,
  non_surge_earnings,
  total_earnings,
  ROUND(surge_earnings * 100.0
        / NULLIF(total_earnings, 0), 1) AS surge_pct
FROM summary
WHERE surge_earnings * 100.0
      / NULLIF(total_earnings, 0) > 60
ORDER BY surge_pct DESC;
