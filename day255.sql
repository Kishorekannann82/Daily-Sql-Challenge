/*
Find Orders Missing Required Events (Double Anti-Join)
Scenario:

You have an order processing pipeline.
Every order must go through these events in order:

PLACED

PAID

SHIPPED

You get the raw event logs:

order_events

order_id	event_type	event_time
1001	PLACED	2024-01-01 10:00
1001	PAID	2024-01-01 10:05
1001	SHIPPED	2024-01-02 09:00
1002	PLACED	2024-01-03 11:00
1002	PAID	2024-01-03 11:10
1003	PLACED	2024-01-04 12:00
1003	SHIPPED	2024-01-05 15:00
1004	PAID	2024-01-06 09:00
1005	PLACED	2024-01-07 08:00
1005	PAID	2024-01-07 08:05
1005	PAID	2024-01-07 08:06
1006	SHIPPED	2024-01-07 09:00
Goal: Detect anomalous orders

Find orders that are missing one or more required events, specifically:

Orders placed but never paid

Orders paid but never shipped

Orders that skipped event order (e.g., shipped without being placed)

Orders with only partial event chains

Return:

order_id

missing_event

anomaly_type

✅ Expected SQL Answer (Anti-Join Based)
WITH
placed AS (
    SELECT DISTINCT order_id FROM order_events WHERE event_type = 'PLACED'
),
paid AS (
    SELECT DISTINCT order_id FROM order_events WHERE event_type = 'PAID'
),
shipped AS (
    SELECT DISTINCT order_id FROM order_events WHERE event_type = 'SHIPPED'
)

-- Now detect anomalies using NOT EXISTS checks
SELECT 
    p.order_id,
    'PAID' AS missing_event,
    'Placed but not Paid' AS anomaly_type
FROM placed p
WHERE NOT EXISTS (SELECT 1 FROM paid pa WHERE pa.order_id = p.order_id)

UNION ALL

SELECT
    pa.order_id,
    'SHIPPED' AS missing_event,
    'Paid but not Shipped' AS anomaly_type
FROM paid pa
WHERE NOT EXISTS (SELECT 1 FROM shipped s WHERE s.order_id = pa.order_id)

UNION ALL

SELECT
    s.order_id,
    'PLACED/PAID' AS missing_event,
    'Shipped without prior events' AS anomaly_type
FROM shipped s
WHERE NOT EXISTS (SELECT 1 FROM placed p WHERE p.order_id = s.order_id)
   OR NOT EXISTS (SELECT 1 FROM paid pa WHERE pa.order_id = s.order_id)
ORDER BY order_id;
