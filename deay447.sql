/*📌 Challenge 2.0 — Day 52: "Dynamic Pricing — Surge Detection from Demand/Supply Ratio"

Scenario:
You're a Data Analyst at a ride-hailing app. Pricing wants to detect surge conditions in near real-time: for each 5-minute window per zone, compute the ratio of ride requests to available drivers, and flag surge pricing if that ratio exceeds 3:1 — but only trigger it if the condition holds for 2 consecutive windows (to avoid flickering surge on/off from momentary blips).

Table: ride_requests

Column	Type
request_id	INT
zone_id	INT
request_time	TIMESTAMP

Table: driver_availability

Column	Type
snapshot_id	INT
zone_id	INT
available_drivers	INT
snapshot_time	TIMESTAMP

Task: Output zone_id, window_start, requests, available_drivers, demand_supply_ratio, surge_triggered — where surge_triggered is TRUE only if this window and the immediately preceding window both had ratio > 3.
*/
WITH windowed_requests AS (
    SELECT 
        zone_id,
        DATE_TRUNC('hour', request_time) 
            + (FLOOR(EXTRACT(MINUTE FROM request_time) / 5) * INTERVAL '5 minutes') AS window_start,
        COUNT(*) AS requests
    FROM ride_requests
    GROUP BY zone_id, DATE_TRUNC('hour', request_time) 
            + (FLOOR(EXTRACT(MINUTE FROM request_time) / 5) * INTERVAL '5 minutes')
),
combined AS (
    SELECT 
        wr.zone_id,
        wr.window_start,
        wr.requests,
        da.available_drivers,
        wr.requests * 1.0 / NULLIF(da.available_drivers, 0) AS demand_supply_ratio
    FROM windowed_requests wr
    JOIN driver_availability da 
        ON wr.zone_id = da.zone_id
        AND wr.window_start = da.snapshot_time
),
with_prev AS (
    SELECT 
        zone_id,
        window_start,
        requests,
        available_drivers,
        demand_supply_ratio,
        LAG(demand_supply_ratio) OVER (
            PARTITION BY zone_id ORDER BY window_start
        ) AS prev_ratio
    FROM combined
)
SELECT 
    zone_id,
    window_start,
    requests,
    available_drivers,
    ROUND(demand_supply_ratio, 2) AS demand_supply_ratio,
    CASE 
        WHEN demand_supply_ratio > 3 
             AND prev_ratio > 3 
        THEN TRUE
        ELSE FALSE
    END AS surge_triggered
FROM with_prev
ORDER BY zone_id, window_start;
