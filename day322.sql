/*
Products never ordered in the last 6 months
You're a data analyst at an e-commerce company. The inventory team wants to find products that have not been ordered in the last 6 months — dead stock candidates. Return the product_id, product_name, and category. Assume today is 2024-07-01.
Table: products
product_id	product_name	category
1	Smartphone	Electronics
2	Laptop	Electronics
3	Headphones	Electronics
4	Blender	Home Appliances
5	Toaster	Home Appliances
Table: orders
order_id	product_id	order_date
1	1	2024-01-15
2	2	2024-02-20
3	1	2024-03-10
4	3	2024-04-05
5	2	2024-05-18
Expected output
product_id	product_name	category
4	Blender	Home Appliances
5	Toaster	Home Appliances
Products 1, 2, and 3 were ordered within the last 6 months (
2024-01-01 to 2024-06-30) → excluded ❌
Products 4 and 5 were not ordered in the last 6 months → included ✅
*/
select p.product_id,p.product_name,p.category
from products p
left join  order-items oi 
on p.product_id=oi.product_id 
and oi.order_date>='2024-01-01'
where oi.order_item_-iud is null 
order by product_id;

--End of the SQl Query;
--Powered by Kishore