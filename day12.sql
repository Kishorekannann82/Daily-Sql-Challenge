--Q10: Identify suppliers whose average delivery time is less than 2 days, but only consider deliveries with quantities greater than 100 units.

--Tables: deliveries (supplier_id, delivery_date, order_date, quantity)
--Amazon Interview Question
select supplier_id
from  suppliers
where quantity>100
group by supplier_id
having avg(datediff(day,order_date,delivery_date))>2;