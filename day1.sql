select distinct(salary) as SecondHighestsalary
from Employee
order by  salary desc
limit 1 offset 1