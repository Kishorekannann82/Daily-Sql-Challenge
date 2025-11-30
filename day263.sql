/*
Inventory Reconciliation with Anti-Joins & Window Logic
Scenario

You maintain an inventory ledger and sales transactions.
Sometimes sales are recorded without enough inventory, which creates negative stock flags.

Tables

inventory
(Stock received into warehouse)

inv_id	product_id	inv_date	qty_in
1	101	2024-01-01	50
2	101	2024-01-10	40
3	102	2024-01-02	30

sales
(Units sold)

sale_id	product_id	sale_date	qty_out
10	101	2024-01-05	20
11	101	2024-01-15	90
12	102	2024-01-03	10
❓Goal:

Detect sales transactions where available stock has dropped below zero
in a running balance model:

Running Stock = SUM(qty_in) – SUM(qty_out)  (ordered by date)


Return:

product_id

sale_date

qty_out

running_stock_after_sale

stock_shortage_flag = YES if < 0

✅ Expected SQL Solution
*/
WITH all_events AS (
    SELECT
        product_id,
        inv_date AS event_date,
        qty_in AS qty_in,
        0 AS qty_out
    FROM inventory

    UNION ALL

    SELECT
        product_id,
        sale_date AS event_date,
        0 AS qty_in,
        qty_out AS qty_out
    FROM sales
),
running AS (
    SELECT
        product_id,
        event_date,
        qty_in,
        qty_out,
        SUM(qty_in - qty_out) OVER (
            PARTITION BY product_id
            ORDER BY event_date,
                     qty_out DESC   -- ensure sale deducted same day first
        ) AS running_stock
    FROM all_events
)
SELECT
    product_id,
    event_date AS sale_date,
    qty_out,
    running_stock AS running_stock_after_sale,
    CASE WHEN qty_out > 0 AND running_stock < 0 THEN 'YES' ELSE 'NO' END AS stock_shortage_flag
FROM running
WHERE qty_out > 0   -- only show sales rows
ORDER BY product_id, sale_date;