/*SQL Question
Write a SQL query to find the top 3 highest-paid employees from the employees table. The output should include the employee's name, salary, and rank. If there's a tie in salary, they should receive the same rank.

Table: employees
| Column Name | Data Type |
|-------------|-----------|
| employee_id | INT |
| employee_name | VARCHAR |
| salary | DECIMAL |

SQL Answer
SQL
*/

SELECT
    employee_name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM
    employees
WHERE
    DENSE_RANK() OVER (ORDER BY salary DESC) <= 3
ORDER BY
    salary DESC;
