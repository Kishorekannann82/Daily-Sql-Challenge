/*
Find customers who let their policy lapse before renewing
You work at an insurance aggregator like Policybazaar. Each policy has a start_date and end_date. A renewal should start the day after the previous policy ends (no gap). Find customers whose renewal had a lapse — i.e. the new policy started more than 1 day after the previous one ended. Return customer_name, old_policy_end, new_policy_start, and lapse_days.
Table: policies
policy_id	customer_name	start_date	end_date
P01	Ramesh	2023-01-01	2023-12-31
P02	Ramesh	2024-01-01	2024-12-31
P03	Sita	2023-03-01	2024-02-29
P04	Sita	2024-03-20	2025-03-19
P05	Vijay	2023-06-01	2024-05-31
P06	Vijay	2024-06-01	2025-05-31
Expected output
customer_name	old_policy_end	new_policy_start	lapse_days
Sita	2024-02-29	2024-03-20	20
Ramesh → P01 ends Dec31, P02 starts Jan1 (next day) → seamless renewal ✅ no lapse
Sita → P03 ends Feb29, P04 starts Mar20 → gap of 20 days ❌ lapsed!
Vijay → P05 ends May31, P06 starts Jun1 (next day) → seamless renewal ✅ no lapse
*/
WITH with_prev AS (
  SELECT
    customer_name,
    start_date,
    end_date,
    LAG(end_date) OVER (
      PARTITION BY customer_name
      ORDER BY start_date
    ) AS prev_end_date
  FROM policies
)
SELECT
  customer_name,
  prev_end_date    AS old_policy_end,
  start_date       AS new_policy_start,
  (start_date - prev_end_date - 1) AS lapse_days
FROM with_prev
WHERE
  prev_end_date IS NOT NULL
  AND (start_date - prev_end_date - 1) > 1
ORDER BY customer_name;
