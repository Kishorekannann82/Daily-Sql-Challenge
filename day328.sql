/*
Managers whose team earns more than them
You work in the HR analytics team. Find all managers whose average team salary is higher than their own salary. Return the manager_name, their salary, and the avg_team_salary rounded to 2 decimal places.
Table: employees
emp_id	name	salary	manager_id
E01	Ravi	90000	NULL
E02	Sundar	75000	E01
E03	Meena	82000	E01
E04	Kiran	60000	E02
E05	Divya	95000	E02
E06	Arjun	88000	E02
E07	Pooja	70000	E03
E08	Nikhil	65000	E03
Expected output
manager_name	manager_salary	avg_team_salary
Sundar	75000	81000.00
Ravi (90000) → team: Sundar(75000), Meena(82000) → avg = 78500 → less than 90000 ❌
Sundar (75000) → team: Kiran(60000), Divya(95000), Arjun(88000) → avg = 81000 → more than 75000 ✅
Meena (82000) → team: Pooja(70000), Nikhil(65000) → avg = 67500 → less than 82000 ❌
*/
select 
m.name as manager_name,
m.salary as salary,
round(avg(salary)) as avg_team_salary
from employees e
join employees m
on e.manager_id=e.emp_id
group by e.emp_id,m.name,m./salary
having eAvg(e.salary)>m.salary
order by m.name;
--Powered by Kishore