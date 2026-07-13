/*
Find employees missing required skills for their role
You work at an L&D (Learning & Development) platform. Each job role has a set of required skills. Each employee has a set of current skills. Find employees who are missing at least one required skill for their role. Return employee_name, role, and missing_skills as a comma-separated list.
Table: employees
emp_id	employee_name	role
E01	Arun	Data Analyst
E02	Bala	Data Analyst
E03	Chitra	Backend Dev
E04	Deepa	Backend Dev
Table: role_skills (required)
role	skill
Data Analyst	SQL
Data Analyst	Python
Data Analyst	Tableau
Backend Dev	Python
Backend Dev	Django
Backend Dev	PostgreSQL
Table: employee_skills (current)
emp_id	skill
E01	SQL
E01	Python
E02	SQL
E02	Tableau
E03	Python
E03	Django
E03	PostgreSQL
E04	Python
Expected output
employee_name	role	missing_skills
Arun	Data Analyst	Tableau
Bala	Data Analyst	Python
Deepa	Backend Dev	Django, PostgreSQL
Arun → has SQL, Python → missing Tableau ❌
Bala → has SQL, Tableau → missing Python ❌
Chitra → has Python, Django, PostgreSQL → all 3 Backend Dev skills ✅ no gap
Deepa → has Python only → missing Django, PostgreSQL ❌
*/
SELECT
  e.employee_name,
  e.role,
  STRING_AGG(rs.skill, ', '
    ORDER BY rs.skill)       AS missing_skills
FROM employees e
JOIN role_skills rs
  ON e.role = rs.role
LEFT JOIN employee_skills es
  ON  e.emp_id = es.emp_id
  AND rs.skill = es.skill
WHERE es.skill IS NULL
GROUP BY e.emp_id, e.employee_name, e.role
ORDER BY e.employee_name;
