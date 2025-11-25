/*
Build an SCD Type-2 History Table From Change Logs
Scenario:

You have a table that records changes to customer attributes over time:

customer_changes
customer_id	customer_name	city	change_date
1	Alice	New York	2024-01-01
1	Alice	Boston	2024-02-10
1	Alice	Chicago	2024-03-05
2	Bob	Miami	2024-01-15
2	Bob	Miami	2024-03-01
3	Carol	Seattle	2024-02-20
Requirements:

Using this change log, build a Type-2 dimension table:

Output Columns

customer_id

customer_name

city

valid_from

valid_to

is_current (YES/NO)

Rules:

Use change_date as the beginning of the validity window

valid_to = the day before the next change

Last record per customer has valid_to = NULL and is_current = 'YES'

✅ Expected SQL Answer (SQL Server / Postgres style)
*/

WITH ordered_changes AS (
    SELECT
        customer_id,
        customer_name,
        city,
        change_date,
        LEAD(change_date) OVER (
            PARTITION BY customer_id
            ORDER BY change_date
        ) AS next_change_date
    FROM customer_changes
),
scd2 AS (
    SELECT
        customer_id,
        customer_name,
        city,
        change_date AS valid_from,
        CASE 
            WHEN next_change_date IS NULL 
                THEN NULL
            ELSE next_change_date - INTERVAL '1 day'
        END AS valid_to,
        CASE 
            WHEN next_change_date IS NULL THEN 'YES'
            ELSE 'NO'
        END AS is_current
    FROM ordered_changes
)
SELECT *
FROM scd2
ORDER BY customer_id, valid_from; 