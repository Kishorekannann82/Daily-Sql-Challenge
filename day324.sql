/*
Calculate month-over-month revenue growth %
You work at a SaaS company. The finance team wants a report showing monthly revenue and the month-over-month growth percentage compared to the previous month. Return month, revenue, prev_month_revenue, and growth_pct rounded to 2 decimal places. Months with no previous data should show NULL for growth.
Table: payments
payment_id	customer_id	amount	payment_date
1	C01	500	2024-01-10
2	C02	300	2024-01-22
3	C03	800	2024-02-05
4	C01	500	2024-02-18
5	C04	200	2024-02-25
6	C02	600	2024-03-07
7	C03	900	2024-03-15
8	C05	400	2024-03-28
Expected output
month	revenue	prev_month_revenue	growth_pct
2024-01	800	NULL	NULL
2024-02	1500	800	87.50
2024-03	1900	1500	26.67
Jan → 500+300 = 800, no previous month → NULL growth
Feb → 800+500+200 = 1500, growth = (1500−800)/800 × 100 = 87.50%
Mar → 600+900+400 = 1900, growth = (1900−1500)/1500 × 100 = 26.67%
*/
WITH monthly AS (
  SELECT
    TO_CHAR(payment_date, 'YYYY-MM') AS month,
    SUM(amount)                      AS revenue
  FROM payments
  GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
),
with_lag AS (
  SELECT
    month,
    revenue,
    LAG(revenue) OVER (
      ORDER BY month
    ) AS prev_month_revenue
  FROM monthly
)
SELECT
  month,
  revenue,
  prev_month_revenue,
  ROUND(
    (revenue - prev_month_revenue) * 100.0
    / prev_month_revenue
  , 2) AS growth_pct
FROM with_lag
ORDER BY month;