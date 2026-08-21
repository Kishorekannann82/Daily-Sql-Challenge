/*
Day 14: "Overlapping Booking Detection"

Scenario:
You're a Data Analyst at a hotel booking platform. Due to a booking-engine bug, some rooms got double-booked — two guests assigned to the same room with overlapping date ranges. Ops needs a query to find every conflicting pair before check-in day.

Table: bookings

Column	Type
booking_id	INT
room_id	INT
guest_name	VARCHAR
check_in	DATE
check_out	DATE

(Assume check_out is exclusive — a guest checking out on the 5th doesn't conflict with someone checking in on the 5th.)

Task: Find all pairs of bookings for the same room whose date ranges overlap. Output room_id, booking_id_1, guest_1, booking_id_2, guest_2, overlap_start, overlap_end — each conflicting pair listed only once (not twice in both directions).
*/
SELECT 
    b1.room_id,
    b1.booking_id AS booking_id_1,
    b1.guest_name AS guest_1,
    b2.booking_id AS booking_id_2,
    b2.guest_name AS guest_2,
    GREATEST(b1.check_in, b2.check_in) AS overlap_start,
    LEAST(b1.check_out, b2.check_out) AS overlap_end
FROM bookings b1
JOIN bookings b2
    ON b1.room_id = b2.room_id
    AND b1.booking_id < b2.booking_id          -- avoid duplicate pairs + self-pairing
WHERE b1.check_in < b2.check_out               -- b1 starts before b2 ends
  AND b2.check_in < b1.check_out               -- b2 starts before b1 ends
ORDER BY b1.room_id, overlap_start;
