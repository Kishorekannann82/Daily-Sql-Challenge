/*
Find patients who were readmitted within 30 days
You work at a hospital chain like Apollo. The medical team wants to track 30-day readmissions — patients who were discharged and then admitted again within 30 days. This is a key healthcare quality metric. Return patient_id, first_discharge, readmission_date, and days_gap.
Table: admissions
admission_id	patient_id	admitted_on	discharged_on
1	P01	2024-01-01	2024-01-05
2	P01	2024-01-20	2024-01-25
3	P01	2024-03-10	2024-03-15
4	P02	2024-02-01	2024-02-07
5	P02	2024-04-01	2024-04-05
6	P03	2024-01-10	2024-01-18
7	P03	2024-02-05	2024-02-10
8	P04	2024-03-01	2024-03-08
Expected output
patient_id	first_discharge	readmission_date	days_gap
P01	2024-01-05	2024-01-20	15
P03	2024-01-18	2024-02-05	18
P01 → discharged Jan 5, readmitted Jan 20 → 15 days ✅ within 30
P01 → discharged Jan 25, readmitted Mar 10 → 44 days ❌ too long
P02 → discharged Feb 7, readmitted Apr 1 → 54 days ❌ too long
P03 → discharged Jan 18, readmitted Feb 5 → 18 days ✅ within 30
P04 → only one admission, no readmission ❌
*/
WITH with_prev AS (
  SELECT
    patient_id,
    admitted_on,
    discharged_on,
    LAG(discharged_on) OVER (
      PARTITION BY patient_id
      ORDER BY admitted_on
    ) AS prev_discharged_on
  FROM admissions
)
SELECT
  patient_id,
  prev_discharged_on                  AS first_discharge,
  admitted_on                         AS readmission_date,
  admitted_on - prev_discharged_on    AS days_gap
FROM with_prev
WHERE
  prev_discharged_on IS NOT NULL
  AND (admitted_on - prev_discharged_on) BETWEEN 1 AND 30
ORDER BY patient_id, readmission_date;