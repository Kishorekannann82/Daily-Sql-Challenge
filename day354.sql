/*
Week-over-week delivery performance by city
You work at a logistics company like Delhivery. The ops team tracks weekly deliveries per city. Find the week-over-week change in deliveries per city — show current week count, previous week count, the absolute change, and a trend label: UP, DOWN, or FLAT. Assume week is identified by week_number.
Table: deliveries
delivery_id	city	week_number	delivered
1	Chennai	1	320
2	Chennai	2	410
3	Chennai	3	390
4	Mumbai	1	500
5	Mumbai	2	500
6	Mumbai	3	620
7	Delhi	1	450
8	Delhi	2	380
9	Delhi	3	410
Expected output (Week 3 vs Week 2)
city	current_week	prev_week	change	trend
Chennai	390	410	-20	DOWN
Delhi	410	380	30	UP
Mumbai	620	500	120	UP
Chennai → W3=390, W2=410 → change=-20 → DOWN 📉
Mumbai → W3=620, W2=500 → change=+120 → UP 📈
Delhi → W3=410, W2=380 → change=+30 → UP 📈
Mumbai W1→W2 same (500=500) would be FLAT — not in output since we compare only latest 2 weeks
*/
WITH with_prev AS (
  SELECT
    city,
    week_number,
    delivered,
    LAG(delivered) OVER (
      PARTITION BY city
      ORDER BY week_number
    )                   AS prev_delivered,
    MAX(week_number) OVER () AS latest_week
  FROM deliveries
)
SELECT
  city,
  delivered           AS current_week,
  prev_delivered      AS prev_week,
  delivered - prev_delivered AS change,
  CASE
    WHEN delivered > prev_delivered THEN 'UP'
    WHEN delivered < prev_delivered THEN 'DOWN'
    ELSE                                  'FLAT'
  END                 AS trend
FROM with_prev
WHERE
  week_number    = latest_week
  AND prev_delivered IS NOT NULL
ORDER BY city;
