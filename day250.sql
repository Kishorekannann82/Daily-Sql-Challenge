/*
Find Salary Percentiles and Rank Distributions per Department

Scenario:
You have the table employees:

emp_id	emp_name	department	salary
1	Alice	Sales	6000
2	Bob	Sales	7000
3	Carol	Sales	8000
4	David	Sales	9000
5	Emma	IT	4000
6	Frank	IT	5000
7	Grace	IT	7000
8	Henry	IT	10000
9	Irene	HR	4500
10	John	HR	6000
11	Kate	HR	7500
❓Question:

For each employee, calculate:

Percentile rank of their salary within their department

Cumulative distribution (CUME_DIST) of their salary within department

Sort results by department and salary

Return:

department

emp_name

salary

percent_rank

cume_dist

✅ Expected Answer (SQL Solution)
*/
SELECT
    department,
    emp_name,
    salary,
    ROUND(PERCENT_RANK() OVER (
        PARTITION BY department
        ORDER BY salary
    ), 2) AS percent_rank,
    ROUND(CUME_DIST() OVER (
        PARTITION BY department
        ORDER BY salary
    ), 2) AS cume_dist
FROM employees
ORDER BY department, salary;