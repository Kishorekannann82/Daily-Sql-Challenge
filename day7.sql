--Calculate the median salary in each department
--Amazon interview question
select distinct department_id,
    percentile_cont(0.5) within group(order by salary)
    over(partition by department_id) as median_salary
from employees;