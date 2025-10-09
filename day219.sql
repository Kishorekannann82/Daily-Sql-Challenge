-- Question:
-- Write an SQL query to find the second highest salary from an Employee table.

-- Answer:
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);