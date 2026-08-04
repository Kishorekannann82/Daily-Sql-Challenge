/*
Find the top 2 most demanded skills per job category
You work at Naukri's data team. Each job posting lists required skills. Find the top 2 most frequently required skills per job category. If there's a tie at position 2, include all tied skills. Return category, skill, job_count, and skill_rank.
Table: job_skills
job_id	category	skill
J01	Data Science	Python
J02	Data Science	Python
J03	Data Science	SQL
J04	Data Science	Python
J05	Data Science	SQL
J06	Data Science	Tableau
J07	Data Science	Tableau
J08	Backend	Java
J09	Backend	Java
J10	Backend	Python
J11	Backend	Django
J12	Backend	Django
J13	Backend	Python
J14	Backend	PostgreSQL
Expected output
category	skill	job_count	skill_rank
Data Science	Python	3	1
Data Science	SQL	2	2
Data Science	Tableau	2	2
Backend	Java	2	1
Backend	Python	2	1
Backend	Django	2	1
Data Science → Python(3) rank 1, SQL(2) & Tableau(2) tied at rank 2 → all included ✅
Backend → Java(2), Python(2), Django(2) all tied at rank 1! All 3 included → PostgreSQL(1) rank 4 ❌
DENSE_RANK handles all ties correctly here
*/
WITH skill_counts AS (
  SELECT
    category,
    skill,
    COUNT(*) AS job_count
  FROM job_skills
  GROUP BY category, skill
),
ranked AS (
  SELECT
    category,
    skill,
    job_count,
    DENSE_RANK() OVER (
      PARTITION BY category
      ORDER BY job_count DESC
    ) AS skill_rank
  FROM skill_counts
)
SELECT
  category,
  skill,
  job_count,
  skill_rank
FROM ranked
WHERE skill_rank <= 2
ORDER BY category, skill_rank, skill;
