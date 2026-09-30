/*
📌 Challenge 2.0 — Day 48: "Detecting Data Entry Errors — Statistical Outliers per Group"

Scenario:
You're a Data Analyst at a logistics company. Drivers log delivery times manually, and some entries are clearly typos (e.g., "45" minutes accidentally logged as "4500"). QC wants to flag outlier delivery times within each route type, since a "long" delivery on a cross-country route is normal but would be a huge red flag on a local same-city route.

Table: deliveries

Column	Type
delivery_id	INT
route_type	VARCHAR
delivery_minutes	DECIMAL

Task: For each route_type, calculate the mean and standard deviation of delivery_minutes, then flag any delivery as an outlier if it's more than 3 standard deviations from the mean (a common statistical outlier rule — "3-sigma rule"). Output delivery_id, route_type, delivery_minutes, route_avg, route_stddev, z_score, is_outlier.
*/
WITH route_stats AS (
    SELECT 
        route_type,
        AVG(delivery_minutes) AS route_avg,
        STDDEV(delivery_minutes) AS route_stddev
    FROM deliveries
    GROUP BY route_type
),
scored AS (
    SELECT 
        d.delivery_id,
        d.route_type,
        d.delivery_minutes,
        rs.route_avg,
        rs.route_stddev,
        (d.delivery_minutes - rs.route_avg) / NULLIF(rs.route_stddev, 0) AS z_score
    FROM deliveries d
    JOIN route_stats rs 
        ON d.route_type = rs.route_type
)
SELECT 
    delivery_id,
    route_type,
    delivery_minutes,
    ROUND(route_avg, 2) AS route_avg,
    ROUND(route_stddev, 2) AS route_stddev,
    ROUND(z_score, 2) AS z_score,
    CASE 
        WHEN ABS(z_score) > 3 THEN 'YES'
        ELSE 'NO'
    END AS is_outlier
FROM scored
ORDER BY ABS(z_score) DESC;
