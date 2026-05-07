/*
Find the most ordered item per restaurant
You work at Zomato. The business team wants to know the single most ordered menu item for each restaurant. If there's a tie, return all tied items. Return restaurant_name, item_name, and total_orders.
Table: restaurants
restaurant_id	restaurant_name
R01	Bombay Bites
R02	Chennai Express
R03	Delhi Darbar
Table: order_items
order_id	restaurant_id	item_name
1	R01	Vada Pav
2	R01	Vada Pav
3	R01	Pav Bhaji
4	R01	Vada Pav
5	R02	Dosa
6	R02	Idli
7	R02	Dosa
8	R02	Idli
9	R03	Butter Chicken
10	R03	Dal Makhani
11	R03	Butter Chicken
12	R03	Naan
Expected output
restaurant_name	item_name	total_orders
Bombay Bites	Vada Pav	3
Chennai Express	Dosa	2
Chennai Express	Idli	2
Delhi Darbar	Butter Chicken	2
*/
with item_count as(
    select 
    oi.restaurant_id,
    oi.item_name,
    count(*) as total_orders
    from order_items oi
    group by oi.restaurant_id, oi.item_name
),
ranked_items as(
    select 
    ic.restaurant_id,
    ic.item_name,
    ic.total_orders,
    rank() over(partition by ic.restaurant_id order by ic.total_orders desc) as rnk
    from item_count ic
)
select
r.restaurant_name,
ri.item_name,
ri.total_orders
from ranked_items ri
join restaurants r
on r.restaurant_id = ri.restaurant_id
where ri.rnk = 1
order by r.restaurant_name, ri.item_name;