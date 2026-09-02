/*
another one with ans

📌 Challenge 2.0 — Day 26: "Gap Detection in Sequential IDs"
Scenario:
You're a Data Analyst at a logistics company. Each shipment gets a sequential tracking_number. Ops suspects some tracking numbers are missing (lost records, failed inserts, or external system skips) and wants every gap identified before a client audit.

Table: shipments

Column	Type
shipment_id	INT
tracking_number	INT
shipped_date	DATE
Task: Find every missing range of tracking numbers between the minimum and maximum tracking number in the table. Output gap_start, gap_end, missing_count — one row per contiguous missing range (not one row per missing number).
*/
WITH ordered AS (
    SELECT 
        tracking_number,
        LEAD(tracking_number) OVER (ORDER BY tracking_number) AS next_tracking_number
    FROM shipments
),
gaps AS (
    SELECT 
        tracking_number + 1 AS gap_start,
        next_tracking_number - 1 AS gap_end
    FROM ordered
    WHERE next_tracking_number - tracking_number > 1
)
SELECT 
    gap_start,
    gap_end,
    gap_end - gap_start + 1 AS missing_count
FROM gaps
ORDER BY gap_start;
