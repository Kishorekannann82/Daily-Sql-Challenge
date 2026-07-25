/*
Identify serial returners — customers abusing return policy
You work at Myntra's risk team. The returns team wants to flag customers whose return rate exceeds 60% AND who have placed at least 5 orders. These are potential return abusers — they order, use the product, and return it. Return customer_id, total_orders, total_returns, return_rate, and risk_flag as HIGH RISK or MONITOR (return rate 40–60% with >= 5 orders).
Table: orders
order_id	customer_id	order_date	is_returned
O01	C01	2024-01-05	1
O02	C01	2024-01-10	1
O03	C01	2024-01-15	1
O04	C01	2024-01-20	0
O05	C01	2024-01-25	1
O06	C02	2024-01-03	1
O07	C02	2024-01-08	1
O08	C02	2024-01-12	0
O09	C02	2024-01-18	0
O10	C02	2024-01-22	1
O11	C03	2024-01-06	0
O12	C03	2024-01-11	0
O13	C03	2024-01-16	1
O14	C04	2024-01-07	1
O15	C04	2024-01-14	1
O16	C04	2024-01-21	1
Expected output
customer_id	total_orders	total_returns	return_rate	risk_flag
C01	5	4	80.0	HIGH RISK
C02	5	3	60.0	MONITOR
C01 → 5 orders, 4 returns → 80% → HIGH RISK ✅
C02 → 5 orders, 3 returns → 60% → exactly 60 → MONITOR (not strictly > 60) ✅
C03 → only 3 orders → fails >= 5 threshold ❌
C04 → only 3 orders, 100% returns → fails >= 5 threshold ❌
*/
WITH return_stats AS (
  SELECT
    customer_id,
    COUNT(*)                                  AS total_orders,
    SUM(is_returned)                          AS total_returns,
    ROUND(SUM(is_returned) * 100.0
          / COUNT(*), 1)                     AS return_rate
  FROM orders
  GROUP BY customer_id
  HAVING COUNT(*) >= 5
)
SELECT
  customer_id,
  total_orders,
  total_returns,
  return_rate,
  CASE
    WHEN return_rate > 60  THEN 'HIGH RISK'
    WHEN return_rate >= 40 THEN 'MONITOR'
  END                        AS risk_flag
FROM return_stats
WHERE return_rate >= 40
ORDER BY return_rate DESC;
