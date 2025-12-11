/*
Write an SQL query to fetch the second highest salary from an Employees table.

Table: Employees

id	name	salary
✅ Answer
Method 1 — Using ORDER BY + LIMIT (MySQL)
*/
SELECT salary 
FROM Employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;