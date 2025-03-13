--identify the customers who purchase the products from all avaiable categories..Table:purchase(customer_id,product_id),products(product_id,category)
--Amazon Interview Question
with categoryCount as(
    select count(distinct category) as categories
    from products
),
CustomerCategory as (
    select pr.customer_id,count(distinct po.category) as CustomerCategory
    from purchase pr 
    join products po
    on pr.product_id=po.product_id
    group by pr.customer_id
)
SELECT ccc.customer_id
FROM CustomerCategoryCount ccc
JOIN CategoryCount cc ON ccc.customer_categories = cc.total_categories;