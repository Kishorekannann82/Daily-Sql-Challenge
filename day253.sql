/*
Find Each Employee’s Best Monthly Sales and Their Ranking Within Region
Scenario:

You have a table showing employee monthly sales:

employee_sales

emp_id	emp_name	region	month	sales
1	Alice	East	2024-01	5000
1	Alice	East	2024-02	7000
1	Alice	East	2024-03	6500
2	Bob	East	2024-01	4000
2	Bob	East	2024-02	8000
2	Bob	East	2024-03	8200
3	Carol	West	2024-01	6000
3	Carol	West	2024-02	6200
3	Carol	West	2024-03	5800
4	David	West	2024-01	7000
4	David	West	2024-02	7100
4	David	West	2024-03	7200
❓QUESTION:

For each employee, find:

Their best month’s sales

Their regional rank based on their best month

Their region average of best-sales

Their percent contribution to region’s best-sales total

Return:

emp_name

region

best_sales

region_rank

region_avg_best_sales

contribution_pct

✅ Expected Answer (SQL Solution)
*/
WITH best_sales AS (
    SELECT
        emp_id,
        emp_name,
        region,
        MAX(sales) AS best_sales
    FROM employee_sales
    GROUP BY emp_id, emp_name, region
),
region_stats AS (
    SELECT
        region,
        AVG(best_sales) AS region_avg_best_sales,
        SUM(best_sales) AS region_total_best_sales
    FROM best_sales
    GROUP BY region
),
ranked AS (
    SELECT
        b.emp_name,
        b.region,
        b.best_sales,
        DENSE_RANK() OVER (
            PARTITION BY b.region 
            ORDER BY b.best_sales DESC
        ) AS region_rank
    FROM best_sales b
)
SELECT
    r.emp_name,
    r.region,
    r.best_sales,
    r.region_rank,
    rs.region_avg_best_sales,
    ROUND((r.best_sales * 100.0 / rs.region_total_best_sales), 2) AS contribution_pct
FROM ranked r
JOIN region_stats rs ON r.region = rs.region
ORDER BY r.region, r.region_rank;