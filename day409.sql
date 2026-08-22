/*
📌 Challenge 2.0 — Day 15: "Pivoting Rows to Columns — Quarterly Sales Report"

Scenario:
You're a Data Analyst at a manufacturing company. Finance wants a pivoted report: one row per product, with separate columns for each quarter's revenue (Q1, Q2, Q3, Q4) — instead of the raw long-format data — for a spreadsheet-style executive summary.

Table: sales

Column	Type
sale_id	INT
product_name	VARCHAR
sale_date	DATE
revenue	DECIMAL

Task: Output product_name, q1_revenue, q2_revenue, q3_revenue, q4_revenue, total_revenue — one row per product, revenue summed within each quarter of the year, written portably (no vendor-specific PIVOT syntax, since Finance's BI tool connects to multiple engines).
*/
SELECT 
    product_name,
    SUM(CASE WHEN EXTRACT(QUARTER FROM sale_date) = 1 THEN revenue ELSE 0 END) AS q1_revenue,
    SUM(CASE WHEN EXTRACT(QUARTER FROM sale_date) = 2 THEN revenue ELSE 0 END) AS q2_revenue,
    SUM(CASE WHEN EXTRACT(QUARTER FROM sale_date) = 3 THEN revenue ELSE 0 END) AS q3_revenue,
    SUM(CASE WHEN EXTRACT(QUARTER FROM sale_date) = 4 THEN revenue ELSE 0 END) AS q4_revenue,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC;
