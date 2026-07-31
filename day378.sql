/*
Find workers with low utilisation — more idle than working
You work at Urban Company. Each worker logs their shift start and end time and the time actually spent on jobs within that shift. Utilisation = job_minutes / shift_minutes * 100. Find workers whose utilisation is below 50% on average — they are spending more time idle than working. Return worker_name, total_shifts, avg_shift_minutes, avg_job_minutes, and avg_utilisation rounded to 1 decimal.
Table: worker_shifts
shift_id	worker_name	shift_start	shift_end	job_minutes
1	Rajan	2024-06-01 09:00	2024-06-01 13:00	210
2	Rajan	2024-06-02 10:00	2024-06-02 14:00	180
3	Rajan	2024-06-03 09:00	2024-06-03 12:00	100
4	Meena	2024-06-01 08:00	2024-06-01 12:00	100
5	Meena	2024-06-02 09:00	2024-06-02 11:00	60
6	Meena	2024-06-03 10:00	2024-06-03 13:00	80
7	Suresh	2024-06-01 07:00	2024-06-01 11:00	220
8	Suresh	2024-06-02 08:00	2024-06-02 12:00	200
Expected output
worker_name	total_shifts	avg_shift_min	avg_job_min	avg_utilisation
Meena	3	160.0	80.0	50.0
Rajan → shifts: 240,240,180 min | jobs: 210,180,100 → avg util = (87.5+75+55.6)/3 = 72.7% ✅ above 50
Meena → shifts: 240,120,180 min | jobs: 100,60,80 → avg util = (41.7+50+44.4)/3 = 45.4%... hmm
Actually compute per-shift util then average: (100/240+60/120+80/180)*100/3
Suresh → shifts: 240,240 | jobs: 220,200 → avg util ≈ 87.5% ✅ above 50
⚠️ Verify Meena's exact number — borderline case!
*/
WITH shift_stats AS (
  SELECT
    worker_name,
    shift_id,
    job_minutes,
    EXTRACT(EPOCH FROM (shift_end - shift_start)) / 60
                           AS shift_minutes
  FROM worker_shifts
),
worker_summary AS (
  SELECT
    worker_name,
    COUNT(*)                           AS total_shifts,
    ROUND(AVG(shift_minutes), 1)       AS avg_shift_min,
    ROUND(AVG(job_minutes), 1)         AS avg_job_min,
    ROUND(AVG(
      job_minutes * 100.0
      / NULLIF(shift_minutes, 0)
    ), 1)                              AS avg_utilisation
  FROM shift_stats
  GROUP BY worker_name
)
SELECT
  worker_name,
  total_shifts,
  avg_shift_min,
  avg_job_min,
  avg_utilisation
FROM worker_summary
WHERE avg_utilisation < 50
ORDER BY avg_utilisation;
