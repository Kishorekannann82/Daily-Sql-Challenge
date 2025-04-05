--Write a SQL quetry to find the employee with the highest salary in each department
--Medium Level Question
--Query
select 
department_id,
employee_id,
f_name,l_name,salary from employees e 
where salary =(select max(salary)  from employees where department_id=e.department_id)