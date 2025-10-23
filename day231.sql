/*
Running Total and Monthly Percentage Contribution

Scenario:
You have a sales dataset showing daily transactions:

sales

sale_id	sale_date	region	amount
1	2024-01-02	East	200
2	2024-01-05	East	300
3	2024-01-10	West	250
4	2024-01-15	East	400
5	2024-02-02	West	500
6	2024-02-05	East	350
7	2024-02-10	West	450
8	2024-02-15	East	400
❓Question:

For each region and month, calculate:

Monthly total sales

Running total of sales up to that month (per region)

Percentage of total each month contributes to that region’s total sales

Return:

region

month (YYYY-MM)

monthly_sales

running_total

pct_contribution

✅ Expected Answer (SQL Solution)
*/

WITH monthly_sales AS (
    SELECT
        region,
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(amount) AS monthly_sales
    FROM sales
    GROUP BY region, DATE_FORMAT(sale_date, '%Y-%m')
),
running_calc AS (
    SELECT
        region,
        month,
        monthly_sales,
        SUM(monthly_sales) OVER (PARTITION BY region ORDER BY month) AS running_total,
        SUM(monthly_sales) OVER (PARTITION BY region) AS region_total
    FROM monthly_sales
)
SELECT
    region,
    month,
    monthly_sales,
    running_total,
    ROUND((monthly_sales * 100.0 / region_total), 2) AS pct_contribution
FROM running_calc
ORDER BY region, month;