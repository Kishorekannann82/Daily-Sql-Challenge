

Scenario:

You have a table called Sales with the following columns:

sale_id (INT, Primary Key)

product_id (INT)

sale_date (DATE)

sale_amount (DECIMAL)

region (VARCHAR)

You want to find the top 3 selling products (by sale_amount) for each region in each month, but only for months where the total sales for that region exceeded $10,000. If a region didn't have total sales over $10,000 in a given month, no products from that region/month combination should appear in the result.
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    sale_amount DECIMAL(10, 2),
    region VARCHAR(50)
);

INSERT INTO Sales (sale_id, product_id, sale_date, sale_amount, region) VALUES
(1, 101, '2024-01-05', 1200.00, 'North'),
(2, 102, '2024-01-08', 800.00, 'North'),
(3, 103, '2024-01-10', 1500.00, 'South'),
(4, 101, '2024-01-12', 1000.00, 'North'),
(5, 104, '2024-01-15', 2000.00, 'South'),
(6, 102, '2024-01-20', 900.00, 'East'),
(7, 105, '2024-01-22', 1800.00, 'East'),
(8, 101, '2024-02-01', 5000.00, 'North'),
(9, 102, '2024-02-05', 3000.00, 'North'),
(10, 103, '2024-02-10', 4000.00, 'South'),
(11, 104, '2024-02-15', 6000.00, 'South'),
(12, 101, '2024-02-20', 2500.00, 'North'),
(13, 102, '2024-03-01', 7000.00, 'North'),
(14, 103, '2024-03-05', 8000.00, 'South'),
(15, 104, '2024-03-10', 9000.00, 'South'),
(16, 105, '2024-03-15', 10000.00, 'East'),
(17, 101, '2024-03-20', 11000.00, 'East'),

(18, 102, '2024-04-01', 1000.00, 'North'); -- Sales for North in April < 10000
WITH MonthlyRegionSales AS (
    -- Calculate total sales for each region in each month
    SELECT
        strftime('%Y-%m', sale_date) AS sale_month,
        region,
        product_id,
        SUM(sale_amount) AS total_product_sale_amount,
        SUM(SUM(sale_amount)) OVER (PARTITION BY strftime('%Y-%m', sale_date), region) AS monthly_region_total_sales
    FROM
        Sales
    GROUP BY
        strftime('%Y-%m', sale_date), region, product_id
),
RankedProductSales AS (
    -- Rank products within each month and region based on their total sales
    SELECT
        sale_month,
        region,
        product_id,
        total_product_sale_amount,
        ROW_NUMBER() OVER (PARTITION BY sale_month, region ORDER BY total_product_sale_amount DESC) AS rn
    FROM
        MonthlyRegionSales
    WHERE
        monthly_region_total_sales > 10000 -- Filter for regions/months with total sales > $10,000
)
SELECT
    sale_month,
    region,
    product_id,
    total_product_sale_amount
FROM
    RankedProductSales
WHERE
    rn <= 3 -- Select only the top 3 selling products
ORDER BY
    sale_month, region, total_product_sale_amount DESC;
