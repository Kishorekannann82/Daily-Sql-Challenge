/*
Maintain SCD Type-2 History (Handle Late Updates)
Scenario

You maintain a customer dimension with full history.
Sometimes updates arrive late and should correct history, not overwrite it.

customer_updates (incoming feed)
customer_id	status	update_time
101	ACTIVE	2024-01-01
101	SUSPENDED	2024-02-01
101	ACTIVE	2024-01-15
102	ACTIVE	2024-01-10
102	CHURNED	2024-03-01
Target table

dim_customer (SCD-2)

customer_id	status	valid_from	valid_to	is_current

📌 Rules

Maintain non-overlapping validity ranges

Late updates must split existing records

Only one row per customer has is_current = 1

❓ Goal

Generate the correct SCD Type-2 history.

✅ Expected SQL Answer

(Logic-focused, works in Postgres / MySQL 8+ / SQL Server)
*/
WITH ordered AS (
    SELECT
        customer_id,
        status,
        update_time,
        LEAD(update_time) OVER (
            PARTITION BY customer_id
            ORDER BY update_time
        ) AS next_update
    FROM customer_updates
),
scd_rows AS (
    SELECT
        customer_id,
        status,
        update_time AS valid_from,
        COALESCE(next_update, '9999-12-31') AS valid_to
    FROM ordered
)
SELECT
    customer_id,
    status,
    valid_from,
    valid_to,
    CASE
        WHEN valid_to = '9999-12-31' THEN 1
        ELSE 0
    END AS is_current
FROM scd_rows
ORDER BY customer_id, valid_from;