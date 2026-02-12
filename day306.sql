/*
 RFM++ Customer Segmentation
Scenario
You want to segment customers using:


Recency (R) → Days since last purchase


Frequency (F) → Total number of orders


Monetary (M) → Total revenue


Profitability (P) → Revenue − Cost



orders
order_idcustomer_idorder_daterevenuecost11012024-01-011006021012024-02-0120012031022024-01-1015010041022024-03-011007051032024-01-1550030061042024-02-208050
📌 Assume analysis date = 2024-04-01

❓ Goal
For each customer compute:


recency_days


frequency


total_revenue


total_profit


r_rank (1–4 quartiles)


f_rank (1–4 quartiles)


m_rank (1–4 quartiles)


profitability_segment



✅ Expected SQL Answer
(Works in MySQL 8+, Postgres, SQL Server)
WITH base AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(*) AS frequency,
        SUM(revenue) AS total_revenue,
        SUM(revenue - cost) AS total_profit
    FROM orders
    GROUP BY customer_id
),
metrics AS (
    SELECT
        customer_id,
        DATEDIFF('2024-04-01', last_order_date) AS recency_days,
        frequency,
        total_revenue,
        total_profit
    FROM base
),
ranked AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY recency_days ASC) AS r_rank,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_rank,
        NTILE(4) OVER (ORDER BY total_revenue DESC) AS m_rank
    FROM metrics
)
SELECT
    customer_id,
    recency_days,
    frequency,
    total_revenue,
    total_profit,
    r_rank,
    f_rank,
    m_rank,
    CASE
        WHEN total_profit > 200 THEN 'HIGH_VALUE'
        WHEN total_profit BETWEEN 100 AND 200 THEN 'MEDIUM_VALUE'
        ELSE 'LOW_VALUE'
    END AS profitability_segment
FROM ranked
ORDER BY customer_id;

*/
🧠 Example Output
customer_idrecency_daysfrequencytotal_revenuetotal_profitsegment101602300120MEDIUM_VALUE10231225080LOW_VALUE103771500200MEDIUM_VALUE1044118030LOW_VALUE

🔥 Why This Is Expert-Level
✔ Full RFM modeling in SQL
✔ Profitability integration (RFM++)
✔ Quartile ranking with NTILE()
✔ Marketing segmentation logic
✔ ML-ready customer scoring dataset

You’ve now reached 77 advanced SQL challenges 🚀
If you want Challenge #78, next options:


📊 SQL-only cohort LTV curve modeling


🧠 Z-score anomaly detection in SQL


⚙️ Dynamic pricing elasticity analysis


Just say “next” 😄