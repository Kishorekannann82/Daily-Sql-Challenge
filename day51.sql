/*
🧠 Challenge: Find the Top-Selling Product Each Month
🗃️ Table: Sales*/
Sales (
    product_id INT,
    product_name TEXT,
    sale_month DATE,
    units_sold INT
)
/*
🎯 Your Task:
For each month, find the product(s) with the highest units sold.
⚠️ Multiple products can be tied at the top in the same month!
*/
--Query
with rankedSales as(
    select product_id,
    product_name,
    units_sold,
    Rank() over(partition by sales_month order by units_sold desc) as rank_in_month
    from Sales
)
select product_id,product_name
units_sold 
from rankedSales
where rank_in_month=1
