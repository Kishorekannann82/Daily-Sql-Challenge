/*
Find products that need restocking within 7 days
You work at Amazon's fulfillment center. Each product has a current stock and a daily average sales rate. Calculate days of stock remaining (current_stock / avg_daily_sales) and flag products that will run out within 7 days as REORDER NOW, within 14 days as REORDER SOON, else OK. Return all products ordered by days remaining.
Table: inventory
product_id	product_name	current_stock	avg_daily_sales
P01	USB Cable	150	25.0
P02	Phone Case	80	8.0
P03	Earphones	30	12.0
P04	Charger	200	15.0
P05	Screen Guard	45	20.0
P06	Power Bank	500	10.0
Expected output
product_name	current_stock	days_remaining	reorder_status
Earphones	30	2.5	REORDER NOW
Screen Guard	45	2.3	REORDER NOW
USB Cable	150	6.0	REORDER NOW
Phone Case	80	10.0	REORDER SOON
Charger	200	13.3	REORDER SOON
Power Bank	500	50.0	OK
Earphones → 30/12 = 2.5 days ❗ REORDER NOW
Screen Guard → 45/20 = 2.25 → 2.3 days ❗ REORDER NOW
USB Cable → 150/25 = 6.0 days ❗ REORDER NOW (under 7)
Phone Case → 80/8 = 10.0 days ⚠️ REORDER SOON
Charger → 200/15 = 13.3 days ⚠️ REORDER SOON
Power Bank → 500/10 = 50.0 days ✅ OK
*/
WITH stock_days AS (
  SELECT
    product_name,
    current_stock,
    avg_daily_sales,
    ROUND(current_stock / NULLIF(avg_daily_sales, 0), 1)
                    AS days_remaining
  FROM inventory
)
SELECT
  product_name,
  current_stock,
  days_remaining,
  CASE
    WHEN days_remaining <= 7  THEN 'REORDER NOW'
    WHEN days_remaining <= 14 THEN 'REORDER SOON'
    ELSE                           'OK'
  END             AS reorder_status
FROM stock_days
ORDER BY days_remaining;
