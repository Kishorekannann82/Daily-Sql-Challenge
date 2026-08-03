/*
Find doctors with high patient no-show rates
You work at Practo. A no-show is when a patient books an appointment but doesn't attend (status = 'no_show'). Find doctors whose no-show rate exceeds 30% across all their appointments. Return doctor_name, total_appointments, no_shows, no_show_rate, and avg_wait_days (average days between booking and appointment date), rounded to 1 decimal.
Table: appointments
appt_id	doctor_name	booked_on	appt_date	status
A01	Dr. Rajan	2024-06-01	2024-06-05	attended
A02	Dr. Rajan	2024-06-02	2024-06-08	no_show
A03	Dr. Rajan	2024-06-03	2024-06-10	no_show
A04	Dr. Rajan	2024-06-05	2024-06-12	attended
A05	Dr. Meena	2024-06-01	2024-06-04	attended
A06	Dr. Meena	2024-06-02	2024-06-06	attended
A07	Dr. Meena	2024-06-03	2024-06-07	no_show
A08	Dr. Meena	2024-06-04	2024-06-09	attended
A09	Dr. Suresh	2024-06-01	2024-06-06	no_show
A10	Dr. Suresh	2024-06-02	2024-06-07	no_show
A11	Dr. Suresh	2024-06-03	2024-06-08	attended
Expected output
doctor_name	total_appts	no_shows	no_show_rate	avg_wait_days
Dr. Rajan	4	2	50.0	7.0
Dr. Suresh	3	2	66.7	5.7
Dr. Rajan → 4 appts, 2 no-shows → 50% ✅ | wait days: 4,6,7,7 → avg=6.0? check
Dr. Meena → 4 appts, 1 no-show → 25% ❌ under threshold
Dr. Suresh → 3 appts, 2 no-shows → 66.7% ✅ | wait days: 5,5,5 → avg=5.0? verify
⚠️ Always verify date differences manually!
*/
WITH doctor_stats AS (
  SELECT
    doctor_name,
    COUNT(*)                                          AS total_appts,
    SUM(CASE WHEN status = 'no_show' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(
      SUM(CASE WHEN status = 'no_show' THEN 1 ELSE 0 END)
      * 100.0 / COUNT(*), 1)                          AS no_show_rate,
    ROUND(AVG(appt_date - booked_on), 1)              AS avg_wait_days
  FROM appointments
  GROUP BY doctor_name
)
SELECT
  doctor_name,
  total_appts,
  no_shows,
  no_show_rate,
  avg_wait_days
FROM doctor_stats
WHERE no_show_rate > 30
ORDER BY no_show_rate DESC;
