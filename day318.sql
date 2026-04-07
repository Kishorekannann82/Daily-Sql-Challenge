/*
You work at an e-commerce company. The business team wants to find customers who placed more than one order within any 30-day window — these are considered high-retention customers. Return their customer_id and how many such repeat order pairs they have.
Table: orders
order_id	customer_id	order_date	amount
1	C001	2024-01-05	1200
2	C001	2024-01-20	850
3	C001	2024-03-10	500
4	C002	2024-02-01	300
5	C002	2024-02-25	400
6	C003	2024-01-01	900
7	C003	2024-04-01	750
Expected output
customer_id	repeat_pairs
C001	1
C002	1
*/
select customer_id,count(*) as repeat_pairs
from orders a join orders b
on a.customer_id = b.customer_id and a.order_id < b.order_id
where datediff(b.order_date, a.order_date) <= 30;

