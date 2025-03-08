--Problem 03: Find the Top 2 Highest-Selling Products for Each Category
--Difficulty: Intermediate
--Write an SQL query to find the top 2 highest-selling products in each category based on total sales.
--Ans
with ranked_sales as(
    select p.category_id,
    s.product_id,
    sum(s.sales_amount) as total_sales,
    Rank() over(partition by p.category order by sum(sales_amount)
    desc ) as rank 
    from sales s 
    join products p on s.product_id=p.product_id
    group by p.category,s.product_id

)
select category,product_id,total_sales
from ranked_sales
where rank <=2;