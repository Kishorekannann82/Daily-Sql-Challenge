/*
Apply the Correct Promotion When Multiple Discounts Overlap
Scenario

You have orders and multiple promotions that may overlap.

orders
order_id	customer_id	order_date	amount
1	101	2024-01-05	200
2	101	2024-01-10	150
3	102	2024-01-12	500
4	103	2024-01-20	100
promotions
promo_id	promo_name	discount_pct	start_date	end_date	priority
1	New Year Sale	10	2024-01-01	2024-01-15	2
2	VIP Promo	20	2024-01-05	2024-01-12	1
3	Winter Flash	15	2024-01-18	2024-01-25	3

📌 Rules:

Multiple promos may apply on the same date

Use the highest priority (lowest number wins)

Discount = amount × discount_pct/100

❓Goal

For each order, determine:

Applicable promo

Discount applied

Final amount after discount

✅ Expected SQL Solution
*/
WITH matched AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        o.amount,
        p.promo_id,
        p.promo_name,
        p.discount_pct,
        p.priority,
        ROW_NUMBER() OVER (
            PARTITION BY o.order_id
            ORDER BY p.priority
        ) AS rn
    FROM orders o
    JOIN promotions p
      ON o.order_date BETWEEN p.start_date AND p.end_date
),
best_promo AS (
    SELECT *
    FROM matched
    WHERE rn = 1
)
SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    promo_name AS applied_promo,
    discount_pct,
    ROUND(amount * (discount_pct / 100.0), 2) AS discount_amount,
    ROUND(amount - amount * (discount_pct / 100.0), 2) AS final_amount
FROM best_promo
ORDER BY order_id;