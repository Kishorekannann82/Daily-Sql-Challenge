/*
Customers Who Bought All Products
📊 Scenario

You have two tables:

products
product_id	product_name
1	Laptop
2	Mouse
3	Keyboard
orders
order_id	customer_id	product_id
1	101	1
2	101	2
3	101	3
4	102	1
5	102	2
6	103	1
7	103	2
8	103	3
9	103	2
🎯 Goal

Find customers who purchased ALL available products at least once.

Return:

customer_id

🧠 Expected Result
customer_id
101
103

✔ Customer 101 bought products 1, 2, 3
✔ Customer 103 bought 1, 2, 3 (even though 2 was bought twice — still valid)
❌ Customer 102 bought only 1 and 2

✅ Expected SQL AnswerCustomers Who Bought All Products
📊 Scenario

You have two tables:

products
product_id	product_name
1	Laptop
2	Mouse
3	Keyboard
orders
order_id	customer_id	product_id
1	101	1
2	101	2
3	101	3
4	102	1
5	102	2
6	103	1
7	103	2
8	103	3
9	103	2
🎯 Goal

Find customers who purchased ALL available products at least once.

Return:

customer_id

🧠 Expected Result
customer_id
101
103

✔ Customer 101 bought products 1, 2, 3
✔ Customer 103 bought 1, 2, 3 (even though 2 was bought twice — still valid)
❌ Customer 102 bought only 1 and 2

✅ Expected SQL Answer
*/
with product_counts as (
    select customer_id, count(distinct product_id) as products_bought
    from orders
    group by customer_id
),
total_products as (
    select count(*) as total
    from products
)
select customer_id
from product_counts, total_products
where products_bought = total;
