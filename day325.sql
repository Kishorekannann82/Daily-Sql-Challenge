/*
Find candidates who applied but never got interviewed
You work at a job portal like LinkedIn. The recruiting team wants to find candidates who have applied to at least 2 jobs but have never been called for an interview for any of them. Return their candidate_id, name, and total_applications.
Table: candidates
candidate_id	name
C01	Arjun
C02	Priya
C03	Rahul
C04	Sneha
Table: applications
app_id	candidate_id	job_id	applied_on
1	C01	J01	2024-03-01
2	C01	J02	2024-03-05
3	C01	J03	2024-03-10
4	C02	J01	2024-03-02
5	C02	J04	2024-03-08
6	C03	J02	2024-03-04
7	C04	J03	2024-03-06
8	C04	J05	2024-03-12
Table: interviews
interview_id	candidate_id	job_id	interview_date
1	C01	J01	2024-03-15
2	C02	J04	2024-03-18
Expected output
candidate_id	name	total_applications
C04	Sneha	2
C01 Arjun → 3 applications, got interviewed for J01 → has interview ❌
C02 Priya → 2 applications, got interviewed for J04 → has interview ❌
C03 Rahul → only 1 application, no interview — but fails the "at least 2" rule ❌
C04 Sneha → 2 applications, zero interviews ever → ✅
*/
SELECT
  c.candidate_id,
  c.name,
  COUNT(a.app_id) AS total_applications
FROM candidates c
JOIN applications a
  ON  c.candidate_id = a.candidate_id
LEFT JOIN interviews i
  ON  c.candidate_id = i.candidate_id
WHERE i.interview_id IS NULL
GROUP BY c.candidate_id, c.name
HAVING COUNT(a.app_id) >= 2
ORDER BY c.candidate_id;