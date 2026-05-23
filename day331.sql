/*
Find orders that took too long to deliver
You work at a quick-commerce company like Blinkit or Dunzo. Each order goes through statuses — placed, picked_up, and delivered. Find all orders where the total delivery time (from placed to delivered) exceeded 45 minutes. Return order_id, placed_at, delivered_at, and delivery_minutes.
Table: order_events
event_id	order_id	status	event_time
1	O01	placed	2024-06-01 10:00:00
2	O01	picked_up	2024-06-01 10:15:00
3	O01	delivered	2024-06-01 10:40:00
4	O02	placed	2024-06-01 11:00:00
5	O02	picked_up	2024-06-01 11:20:00
6	O02	delivered	2024-06-01 12:05:00
7	O03	placed	2024-06-01 13:00:00
8	O03	picked_up	2024-06-01 13:10:00
9	O03	delivered	2024-06-01 13:38:00
10	O04	placed	2024-06-01 14:00:00
11	O04	picked_up	2024-06-01 14:30:00
12	O04	delivered	2024-06-01 15:00:00
Expected output
order_id	placed_at	delivered_at	delivery_minutes
O02	2024-06-01 11:00:00	2024-06-01 12:05:00	65
O04	2024-06-01 14:00:00	2024-06-01 15:00:00	60
O01 → 10:00 to 10:40 = 40 mins ✅ within limit
O02 → 11:00 to 12:05 = 65 mins ❌ too slow
O03 → 13:00 to 13:38 = 38 mins ✅ within limit
O04 → 14:00 to 15:00 = 60 mins ❌ too slow
*/
WITH order_times AS (
  SELECT
    order_id,
    MAX(CASE WHEN status = 'placed'    THEN event_time END) AS placed_at,
    MAX(CASE WHEN status = 'delivered' THEN event_time END) AS delivered_at
  FROM order_events
  GROUP BY order_id
)
SELECT
  order_id,
  placed_at,
  delivered_at,
  EXTRACT(EPOCH FROM (delivered_at - placed_at)) / 60 AS delivery_minutes
FROM order_times
WHERE
  EXTRACT(EPOCH FROM (delivered_at - placed_at)) / 60 > 45
ORDER BY delivery_minutes DESC;