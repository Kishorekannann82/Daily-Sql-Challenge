/*
🧠 Challenge: Monthly Leaderboard with Ranks
🗃️ Table: Sales
*/
Sales (
    salesperson_id INT,
    sale_amount DECIMAL,
    sale_date DATE
)
/*
🎯 Your Task:
For each month, rank salespeople based on their total sales, and return their rank, total sales, and the month. Handle ties by assigning the same rank (dense ranking
*/
WITH MonthlySales AS (
    SELECT
        salesperson_id,
        SUM(sale_amount) AS total_sales,
        DATE_TRUNC('month', sale_date) AS sales_month
    FROM
        Sales
    GROUP BY
        salesperson_id,
        DATE_TRUNC('month', sale_date)
)
SELECT
    sales_month,
    salesperson_id,
    total_sales,
    DENSE_RANK() OVER (PARTITION BY sales_month ORDER BY total_sales DESC) AS rank
FROM
    MonthlySales
ORDER BY
    sales_month,
    rank;
