/*
Find connecting flights with a valid layover
You work at IndiGo. A passenger wants to fly from city A to city C with one layover at city B. A layover is valid if the gap between the arrival of the first flight and departure of the second flight is between 1 and 4 hours. Find all valid connecting flight pairs. Return flight1, flight2, from_city, via_city, to_city, and layover_hours.
Table: flights
flight_no	from_city	to_city	departure	arrival
6E101	Chennai	Mumbai	2024-06-01 08:00	2024-06-01 10:00
6E202	Mumbai	Delhi	2024-06-01 11:30	2024-06-01 13:30
6E303	Mumbai	Delhi	2024-06-01 15:30	2024-06-01 17:30
6E404	Chennai	Bangalore	2024-06-01 09:00	2024-06-01 10:00
6E505	Bangalore	Delhi	2024-06-01 10:15	2024-06-01 12:30
6E606	Bangalore	Kolkata	2024-06-01 13:30	2024-06-01 15:30
Expected output
flight1	flight2	from_city	via_city	to_city	layover_hours
6E101	6E202	Chennai	Mumbai	Delhi	1.5
6E404	6E606	Chennai	Bangalore	Kolkata	3.5
6E101 lands Mumbai 10:00, 6E202 leaves Mumbai 11:30 → 1.5h gap ✅ valid
6E101 lands Mumbai 10:00, 6E303 leaves Mumbai 15:30 → 5.5h gap ❌ too long
6E404 lands Bangalore 10:00, 6E505 leaves Bangalore 10:15 → 0.25h ❌ too short (min 1h)
6E404 lands Bangalore 10:00, 6E606 leaves Bangalore 13:30 → 3.5h ✅ valid
*/
SELECT
  f1.flight_no  AS flight1,
  f2.flight_no  AS flight2,
  f1.from_city,
  f1.to_city    AS via_city,
  f2.to_city,
  EXTRACT(EPOCH FROM (f2.departure - f1.arrival)) / 3600
                AS layover_hours
FROM flights f1
JOIN flights f2
  ON  f1.to_city = f2.from_city
  AND f1.flight_no != f2.flight_no
WHERE
  EXTRACT(EPOCH FROM (f2.departure - f1.arrival)) / 3600
  BETWEEN 1 AND 4
ORDER BY f1.flight_no;
