/*You have two tables: employees and departments.

employees has columns: employee_id, employee_name, department_id, and salary.

departments has columns: department_id, and department_name.

Your task is to write a single SQL query that returns the names of all departments where the average salary is higher than the overall average salary of all employees across all departments. The result should be ordered by the department name in ascending order.
*/
Answer:

SQL

SELECT
  d.department_name
FROM
  employees AS e
JOIN
  departments AS d
  ON e.department_id = d.department_id
GROUP BY
  d.department_name
HAVING
  AVG(e.salary) > (
    SELECT AVG(salary)
    FROM employees
  )
ORDER BY
  d.department_name ASC;
Explanation:

SELECT d.department_name: This specifies the column we want to return, which is the name of the department.

FROM employees AS e JOIN departments AS d ON e.department_id = d.department_id: This is the core of the query. We join the employees and departments tables on their common column, department_id. This allows us to link employee salary data to their corresponding department names. We use aliases (e and d) for brevity and readability.

GROUP BY d.department_name: This is a crucial step. It groups the rows by department name. The AVG(e.salary) function that follows will then be calculated for each of these groups (i.e., for each department).

HAVING AVG(e.salary) > (...): This is where the advanced logic lies. The HAVING clause is used to filter groups created by GROUP BY. It is similar to a WHERE clause but operates on aggregated data. Here, we are filtering for groups where the average salary (AVG(e.salary)) is greater than a specific value.

SELECT AVG(salary) FROM employees: This is a subquery. It's an independent query that is executed first. It calculates the overall average salary of all employees in the employees table. The result of this subquery is a single value that is then used by the outer query's HAVING clause for comparison.

ORDER BY d.department_name ASC: Finally, this sorts the resulting department names in alphabetical order, as requested.









