/*
Detect overbooked hotel rooms
You work at OYO. A room is overbooked if two or more bookings for the same room have overlapping stay dates. Find all such rooms and return room_id, booking_1, booking_2, guest_1, guest_2 and the overlap period (overlap_start, overlap_end).
Table: bookings
booking_id	room_id	guest_name	check_in	check_out
B01	R101	Anand	2024-06-01	2024-06-05
B02	R101	Banu	2024-06-04	2024-06-08
B03	R101	Charan	2024-06-10	2024-06-12
B04	R202	Divya	2024-06-03	2024-06-07
B05	R202	Elan	2024-06-07	2024-06-10
B06	R303	Fiona	2024-06-01	2024-06-06
B07	R303	Ganesh	2024-06-05	2024-06-09
Expected output
room_id	booking_1	booking_2	guest_1	guest_2	overlap_start	overlap_end
R101	B01	B02	Anand	Banu	2024-06-04	2024-06-05
R303	B06	B07	Fiona	Ganesh	2024-06-05	2024-06-06
R101 → Anand (Jun1-5), Banu (Jun4-8) → overlap Jun4 to Jun5 ✅ overbooked!
R101 → Charan (Jun10-12) doesn't overlap either → fine ✅
R202 → Divya (Jun3-7), Elan (Jun7-10) → checkout=checkin, touching not overlapping ❌
R303 → Fiona (Jun1-6), Ganesh (Jun5-9) → overlap Jun5 to Jun6 ✅ overbooked!
*/
SELECT
  b1.room_id,
  b1.booking_id                              AS booking_1,
  b2.booking_id                              AS booking_2,
  b1.guest_name                              AS guest_1,
  b2.guest_name                              AS guest_2,
  GREATEST(b1.check_in,  b2.check_in)       AS overlap_start,
  LEAST   (b1.check_out, b2.check_out)      AS overlap_end
FROM bookings b1
JOIN bookings b2
  ON  b1.room_id    = b2.room_id
  AND b1.booking_id < b2.booking_id
WHERE
  b1.check_in  < b2.check_out
  AND b2.check_in  < b1.check_out
ORDER BY b1.room_id;
