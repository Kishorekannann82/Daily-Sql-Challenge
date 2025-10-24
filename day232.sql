/*
Find Customers Who Spent More Than the Average in Their City

Scenario:
You have two tables:

customers

customer_id	customer_name	city
1	Alice	New York
2	Bob	New York
3	Carol	Chicago
4	David	Chicago
5	Eva	Boston

orders

order_id	customer_id	amount
101	1	300
102	1	200
103	2	150
104	2	100
105	3	250
106	3	200
107	4	100
108	5	400
❓Question:

Write a SQL query to find customers whose total spending is above the average total spending of all customers in the same city.

Return:

customer_name

city

total_spent

city_avg

✅ Expected Answer (SQL Solution)
*/
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.city
)
SELECT 
    ct.customer_name,
    ct.city,
    ct.total_spent,
    (
        SELECT AVG(ct2.total_spent)
        FROM customer_totals ct2
        WHERE ct2.city = ct.city
    ) AS city_avg
FROM customer_totals ct
WHERE ct.total_spent >
      (
        SELECT AVG(ct3.total_spent)
        FROM customer_totals ct3
        WHERE ct3.city = ct.city
      )
ORDER BY ct.city, ct.total_spent DESC;