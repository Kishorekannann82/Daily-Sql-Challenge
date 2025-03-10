--detect anamalies where sales for a product are 50% lower than the average for that product..
--Amazon Interview question
--Query
with avg_sales as (
    select product_id,avg(sales) as average_sales
    from sales_data
    group by product_id
)
select s.id,s.product_id,s.sales,a.avg_sales,(a.avg_sales/2) as thereshold
from sales_data s 
join avg_sales a 
on s.product_id=a.product_id
where s.sales < (a.avg_sales/2);
