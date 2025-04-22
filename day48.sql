/*
🏆 Challenge: Find Products with Increasing Sales 3 Months in a Row
📦 Table: Sales
*/
Sales (
    product_id INT,
    sale_month DATE,
    units_sold INT
)
--🎯 Your Task:
--Find all products that had 3 consecutive months with increasing units sold.
with salesLag as(
    select product_id,
    sales_month,
    units_sold,
    lag(units_sold,1) over(partition by order by sales_month) as prev1,
    lag(units_sold,2) over(partition by order by sale_month) as prev2
    from Sales
)
select distinct product_id
from salesLag
where 
    prev2 is not null and
    prev2<prev1 and
    prev1<units_sold ;
