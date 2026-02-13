/*
Estimate Price Elasticity of Demand
📊 Scenario

You track daily product pricing and units sold.

product_sales
sale_date	product_id	price	units_sold
2024-01-01	A	100	50
2024-01-02	A	110	45
2024-01-03	A	120	40
2024-01-04	A	90	60
2024-01-05	A	80	70
📌 Price Elasticity Formula

Economics approximation:

Elasticity=
%ΔPrice
%ΔQuantity
	​


Using consecutive days:

🎯 Goal

For each day (except first):

Return:

sale_date

price

units_sold

pct_change_price

pct_change_quantity

elasticity

✅ Expected SQL Answer

(Works in MySQL 8+, PostgreSQL, SQL Server)
*/
WITH ordered AS (
    SELECT
        sale_date,
        product_id,
        price,
        units_sold,
        LAG(price) OVER (
            PARTITION BY product_id
            ORDER BY sale_date
        ) AS prev_price,
        LAG(units_sold) OVER (
            PARTITION BY product_id
            ORDER BY sale_date
        ) AS prev_units
    FROM product_sales
)
SELECT
    sale_date,
    price,
    units_sold,
    ROUND((price - prev_price) / prev_price, 4) AS pct_change_price,
    ROUND((units_sold - prev_units) / prev_units, 4) AS pct_change_quantity,
    ROUND(
        ((units_sold - prev_units) / prev_units)
        /
        ((price - prev_price) / prev_price),
        4
    ) AS elasticity
FROM ordered
WHERE prev_price IS NOT NULL
ORDER BY sale_date;