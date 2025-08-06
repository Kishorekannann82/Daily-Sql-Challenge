The Problem
Here are the two tables you will be working with:

employees
| id | name | salary | dept_id |
| :--- | :--- | :--- | :--- |
| 1 | Alice | 60000 | 1 |
| 2 | Bob | 75000 | 2 |
| 3 | Charlie | 80000 | 1 |
| 4 | David | 95000 | 3 |
| 5 | Eva | 55000 | 2 |
| 6 | Frank | 110000 | 3 |
| 7 | Grace | 70000 | 1 |
| 8 | Hannah | 85000 | 2 |
| 9 | Ivy | 100000 | 3 |

departments
| id | name |
| :--- | :--- |
| 1 | Engineering |
| 2 | Marketing |
| 3 | Sales |

Write a single SQL query that returns the following columns:

department_name: The name of the department.

employee_name: The name of the employee.

employee_salary: The employee's salary.

department_avg_salary: The average salary for that employee's department.

The results should be ordered by department name and then by employee name.

The Solution
SQL

WITH DepartmentAverage AS (
    SELECT
        d.name AS department_name,
        d.id AS department_id,
        AVG(e.salary) AS avg_salary
    FROM
        employees e
    JOIN
        departments d ON e.dept_id = d.id
    GROUP BY
        d.id, d.name
),
RankedDepartments AS (
    SELECT
        department_id,
        department_name,
        avg_salary
    FROM
        DepartmentAverage
    ORDER BY
        avg_salary DESC
    LIMIT 3
)
SELECT
    rd.department_name,
    e.name AS employee_name,
    e.salary AS employee_salary,
    rd.avg_salary AS department_avg_salary
FROM
    employees e
JOIN
    RankedDepartments rd ON e.dept_id = rd.department_id
WHERE
    e.salary > rd.avg_salary
ORDER BY
    rd.department_name,
    e.name;
