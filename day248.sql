/*
Find Salary Quartiles per Department

Scenario:
You have the following employee table:

employees

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

For each department, divide employees into quartiles (Q1–Q4) based on their salaries.

Return:

department

emp_name

salary

salary_quartile

✅ Expected Answer (SQL Solution)
*/

SELECT
    department,
    emp_name,
    salary,
    NTILE(4) OVER (
        PARTITION BY department
        ORDER BY salary
    ) AS salary_quartile
FROM employees
ORDER BY department, salary;