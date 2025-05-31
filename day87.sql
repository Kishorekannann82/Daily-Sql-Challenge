/*

Problem: Analyzing Customer Order Trends
You are given two tables:
 * Customers:
   * customer_id (INTEGER, Primary Key)
   * customer_name (VARCHAR)
   * registration_date (DATE)
 * Orders:
   * order_id (INTEGER, Primary Key)
   * customer_id (INTEGER, Foreign Key to Customers)
   * order_date (DATE)
   * total_amount (DECIMAL)
Task:
Write a SQL query that returns the customer_name and the month and year of their second order. If a customer has less than two orders, they should not be included in the result. The results should be ordered by customer_name alphabetically.
Expected Output Columns:
 * customer_name
 * second_order_month_year (formatted as 'YYYY-MM')
Example Data:
Customers Table:
| customer_id | customer_name | registration_date |
|---|---|---|
| 1 | Alice | 2022-01-10 |
| 2 | Bob | 2022-02-15 |
| 3 | Charlie | 2022-03-01 |
| 4 | David | 2022-04-20 |
Orders Table:
| order_id | customer_id | order_date | total_amount |
|---|---|---|---|
| 101 | 1 | 2022-01-20 | 50.00 |
| 102 | 2 | 2022-02-25 | 75.00 |
| 103 | 1 | 2022-03-05 | 120.00 |
| 104 | 3 | 2022-03-10 | 30.00 |
| 105 | 1 | 2022-04-01 | 90.00 |
| 106 | 2 | 2022-05-15 | 60.00 |
| 107 | 4 | 2022-04-25 | 45.00 |
Expected Result (based on example data):
| customer_name | second_order_month_year |
|---|---|
| Alice | 2022-03 |
| Bob | 2022-05 |
Concepts to utilize for solving this problem:
 * JOIN (specifically INNER JOIN)
 * Window Functions (e.g., ROW_NUMBER())
 * PARTITION BY and ORDER BY within window functions
 * WHERE clause to filter results
 * Date formatting functions (e.g., TO_CHAR for PostgreSQL, FORMAT for SQL Server, DATE_FORMAT for MySQL)

*/
SELECT
    c.customer_name,
    -- PostgreSQL / Oracle
    -- TO_CHAR(o.order_date, 'YYYY-MM') AS second_order_month_year
    -- MySQL
    -- DATE_FORMAT(o.order_date, '%Y-%m') AS second_order_month_year
    -- SQL Server
    FORMAT(o.order_date, 'yyyy-MM') AS second_order_month_year
FROM
    Customers c
INNER JOIN
    (SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as rn
    FROM
        Orders) o
ON
    c.customer_id = o.customer_id
WHERE
    o.rn = 2
ORDER BY
    c.customer_name;
