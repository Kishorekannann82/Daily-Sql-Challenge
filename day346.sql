/*
Full customer lifetime value (LTV) report
You work at an e-commerce company. The analytics team wants a full LTV (Lifetime Value) report per customer showing:

→ total_orders — how many orders they placed
→ total_spent — total revenue from them
→ avg_order_value — average spend per order
→ first_order_date and latest_order_date
→ customer_lifespan_days — days between first and last order
→ ltv_segment — High (spent >= 5000), Mid (2000–4999), Low (below 2000)

Only include customers with at least 2 orders. Order by total_spent DESC.
Table: customers
customer_id	name
C01	Arun
C02	Banu
C03	Chetan
C04	Deepa
C05	Ezhil
Table: orders
order_id	customer_id	order_date	amount
O01	C01	2024-01-05	1200
O02	C01	2024-02-10	1800
O03	C01	2024-03-15	2500
O04	C02	2024-01-20	3200
O05	C02	2024-03-05	1500
O06	C03	2024-02-01	800
O07	C03	2024-02-20	950
O08	C03	2024-04-10	600
O09	C04	2024-01-15	5500
O10	C04	2024-04-01	700
O11	C05	2024-03-01	400
Expected output
name	total_orders	total_spent	avg_order_value	first_order	latest_order	lifespan_days	ltv_segment
Deepa	2	6200	3100.0	2024-01-15	2024-04-01	77	High
Arun	3	5500	1833.3	2024-01-05	2024-03-15	69	High
Banu	2	4700	2350.0	2024-01-20	2024-03-05	45	Mid
Chetan	3	2350	783.3	2024-02-01	2024-04-10	69	Mid
C05 Ezhil → only 1 order → excluded (needs >= 2) ❌
C04 Deepa → 5500+700=6200 → High 🏆
C01 Arun → 1200+1800+2500=5500 → High 🏆
C02 Banu → 3200+1500=4700 → Mid
C03 Chetan → 800+950+600=2350 → Mid
*/
SELECT
  c.name,
  COUNT(o.order_id)                       AS total_orders,
  SUM(o.amount)                           AS total_spent,
  ROUND(AVG(o.amount), 1)               AS avg_order_value,
  MIN(o.order_date)                       AS first_order_date,
  MAX(o.order_date)                       AS latest_order_date,
  MAX(o.order_date) - MIN(o.order_date)  AS customer_lifespan_days,
  CASE
    WHEN SUM(o.amount) >= 5000 THEN 'High'
    WHEN SUM(o.amount) >= 2000 THEN 'Mid'
    ELSE                           'Low'
  END                                     AS ltv_segment
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2
ORDER BY total_spent DESC;
