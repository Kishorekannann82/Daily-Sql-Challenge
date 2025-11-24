/*
Fill Missing Daily Sales & Interpolate Values
Scenario:

You have a table of product sales — but sales weren’t recorded every day:

daily_sales

product_id	sale_date	sales
101	2024-01-01	100
101	2024-01-03	160
101	2024-01-06	220
102	2024-01-02	300
102	2024-01-05	450

✅ We want continuous daily data for each product.

❓Question:

For each product:

Generate missing dates between MIN & MAX sale_date

Forward & backward fill to enable interpolation

Use linear interpolation to estimate missing daily sales

Final Output Should Include:

product_id

sale_date

interpolated_sales

✅ Assume you’re using PostgreSQL.

✅ Expected SQL Answer
*/
WITH date_ranges AS (
    SELECT
        product_id,
        MIN(sale_date) AS start_date,
        MAX(sale_date) AS end_date
    FROM daily_sales
    GROUP BY product_id
),
all_dates AS (
    SELECT
        dr.product_id,
        d::date AS sale_date
    FROM date_ranges dr
    CROSS JOIN LATERAL generate_series(dr.start_date, dr.end_date, interval '1 day') d
),
merged AS (
    SELECT
        a.product_id,
        a.sale_date,
        ds.sales,
        -- nearest previous known sales
        LAST_VALUE(ds.sales) OVER (
            PARTITION BY a.product_id
            ORDER BY a.sale_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS prev_sales,
        -- nearest next known sales
        FIRST_VALUE(ds.sales) OVER (
            PARTITION BY a.product_id
            ORDER BY a.sale_date
            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
        ) AS next_sales,
        -- distance to nearest known points
        COUNT(ds.sales) OVER (
            PARTITION BY a.product_id
            ORDER BY a.sale_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS prev_index,
        COUNT(ds.sales) OVER (
            PARTITION BY a.product_id
            ORDER BY a.sale_date
            ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
        ) AS next_index
    FROM all_dates a
    LEFT JOIN daily_sales ds
        ON a.product_id = ds.product_id
       AND a.sale_date = ds.sale_date
),
final AS (
    SELECT
        product_id,
        sale_date,
        CASE
            WHEN sales IS NOT NULL THEN sales
            ELSE
                -- Linear interpolation formula:
                prev_sales +
                (next_sales - prev_sales) *
                (1.0 * (next_index - 1) / (prev_index + next_index - 2))
        END AS interpolated_sales
    FROM merged
)
SELECT *
FROM final
ORDER BY product_id, sale_date;