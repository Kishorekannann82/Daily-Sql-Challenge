--Write a sql query to list the employees who have worked in kkore than one depatment
--Medium Level Query
--Query
select employee_id,employee_name from employee_department 
group by employee_id
having count(Distinct depatment_id) >1;