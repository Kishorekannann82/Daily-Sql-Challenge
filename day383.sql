/*
Build a driver earnings distribution histogram
You work at Rapido's driver analytics team. Build an earnings distribution showing how many drivers fall into each earnings band this month. Bands: 0–500, 501–1000, 1001–2000, 2001–5000, 5000+. Return earnings_band, driver_count, pct_of_drivers rounded to 1 decimal, and avg_earnings_in_band rounded to 0 decimal.
Table: driver_earnings
driver_id	total_earnings
D01	320
D02	850
D03	1200
D04	4800
D05	6500
D06	450
D07	980
D08	1800
D09	3200
D10	7200
Expected output
earnings_band	driver_count	pct_of_drivers	avg_earnings_in_band
0-500	2	20.0	385
501-1000	2	20.0	915
1001-2000	2	20.0	1500
2001-5000	2	20.0	4000
5000+	2	20.0	6850
0-500: D01(320), D06(450) → avg=385 ✅
501-1000: D02(850), D07(980) → avg=915 ✅
1001-2000: D03(1200), D08(1800) → avg=1500 ✅
2001-5000: D04(4800), D09(3200) → avg=4000 ✅
5000+: D05(6500), D10(7200) → avg=6850 ✅
*/
WITH banded AS (
  SELECT
    driver_id,
    total_earnings,
    CASE
      WHEN total_earnings <=  500 THEN '0-500'
      WHEN total_earnings <= 1000 THEN '501-1000'
      WHEN total_earnings <= 2000 THEN '1001-2000'
      WHEN total_earnings <= 5000 THEN '2001-5000'
      ELSE                             '5000+'
    END AS earnings_band,
    CASE
      WHEN total_earnings <=  500 THEN 1
      WHEN total_earnings <= 1000 THEN 2
      WHEN total_earnings <= 2000 THEN 3
      WHEN total_earnings <= 5000 THEN 4
      ELSE                             5
    END AS band_order
  FROM driver_earnings
),
summary AS (
  SELECT
    earnings_band,
    band_order,
    COUNT(*)                               AS driver_count,
    ROUND(AVG(total_earnings))              AS avg_earnings_in_band
  FROM banded
  GROUP BY earnings_band, band_order
)
SELECT
  earnings_band,
  driver_count,
  ROUND(driver_count * 100.0
        / SUM(driver_count) OVER (), 1) AS pct_of_drivers,
  avg_earnings_in_band
FROM summary
ORDER BY band_order;
