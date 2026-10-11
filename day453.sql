/*
📌 Challenge 2.0 — Day 58: “Seat Availability: Overbooked Flights Detection”

Scenario:
You’re a Data Analyst at an airline. Revenue management deliberately sells a few seats beyond capacity (overbooking), but only up to 5%. Ops wants every flight where confirmed bookings exceed capacity, and a flag for flights that are over the 5% limit (a compliance breach).

Table: flights

Column	Type
flight_id	INT
flight_date	DATE
seat_capacity	INT

Table: bookings

Column	Type
booking_id	INT
flight_id	INT
status	VARCHAR
passengers	INT

Task: For each flight, calculate seats sold (confirmed bookings only, summing passengers), and output only flights where seats sold > capacity. Output flight_id, flight_date, seat_capacity, seats_sold, overbooked_by, overbook_pct, compliance_breach.
*/

WITH seats_sold AS (
    SELECT 
        flight_id,
        SUM(passengers) AS seats_sold
    FROM bookings
    WHERE status = 'confirmed'          -- cancelled/waitlisted don't occupy seats
    GROUP BY flight_id
)
SELECT 
    f.flight_id,
    f.flight_date,
    f.seat_capacity,
    s.seats_sold,
    s.seats_sold - f.seat_capacity AS overbooked_by,
    ROUND((s.seats_sold - f.seat_capacity) * 100.0 / f.seat_capacity, 2) AS overbook_pct,
    CASE 
        WHEN s.seats_sold > f.seat_capacity * 1.05 THEN 'YES'
        ELSE 'NO'
    END AS compliance_breach
FROM flights f
JOIN seats_sold s 
    ON f.flight_id = s.flight_id
WHERE s.seats_sold > f.seat_capacity
ORDER BY overbook_pct DESC;
