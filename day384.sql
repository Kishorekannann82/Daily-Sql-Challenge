/*
Scenario:
You work as a Data Analyst for a subscription-based streaming company (like Netflix). The business team wants to identify customers who are at risk of churning — defined as customers who haven't made any payment in the last 60 days but were active before that.

Tables:

customers

Column	Type
customer_id	INT
name	VARCHAR
signup_date	DATE

payments

Column	Type
payment_id	INT
customer_id	INT
payment_date	DATE
amount	DECIMAL

Task:
Write a query to find all customers whose most recent payment was made more than 60 days ago from today (CURRENT_DATE), but who have made at least one payment ever (so we exclude customers who never subscribed/paid at all).

Output: customer_id, name, last_payment_date, days_since_last_payment
*/
SELECT 
    c.customer_id,
    c.name,
    MAX(p.payment_date) AS last_payment_date,
    DATEDIFF(CURRENT_DATE, MAX(p.payment_date)) AS days_since_last_payment
FROM customers c
JOIN payments p 
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.name
HAVING MAX(p.payment_date) < CURRENT_DATE - INTERVAL 60 DAY
ORDER BY days_since_last_payment DESC;
