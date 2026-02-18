/*
Top 2 Earners Per Department
📊 Scenario

You have an employee table:

employees
emp_id	emp_name	department	salary
1	Alice	HR	60000
2	Bob	HR	75000
3	Charlie	HR	72000
4	David	IT	90000
5	Eva	IT	85000
6	Frank	IT	92000
7	Grace	Sales	70000
8	Henry	Sales	68000
🎯 Goal

For each department:

Return the top 2 highest-paid employees

If salaries tie, include both (use DENSE_RANK)

Return:

department

emp_name

salary

rank_in_department*/
with ranked as(
    select department, emp_name, salary,
    dense_rank() over(partition by department order by salary desc) as rank_in_department
    from employees
)
select department, emp_name, salary, rank_in_department
from ranked
where rank_in_department <= 2
order by department, rank_in_department;