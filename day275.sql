/*
Deduplicate Customer Records Using Survivorship Logic
Scenario

You receive customer data from multiple sources.
The same customer may appear multiple times with partial or conflicting data.

customers_raw

customer_id	email	phone	updated_at	source
1	a@gmail.com
	NULL	2024-01-05	web
1	NULL	9876543210	2024-01-10	mobile
1	a@gmail.com
	9876543210	2024-01-15	crm
2	b@gmail.com
	NULL	2024-01-08	web
2	b@gmail.com
	9123456789	2024-01-12	mobile
3	c@gmail.com
	NULL	2024-01-20	web
📌 Survivorship Rules

For each customer_id:

Pick the most recently updated record

Prefer non-null values over null

If multiple rows exist:

Email → take latest non-null email

Phone → take latest non-null phone

Keep one final record per customer

❓ Expected Output
customer_id	email	phone	last_updated
1	a@gmail.com
	9876543210	2024-01-15
2	b@gmail.com
	9123456789	2024-01-12
3	c@gmail.com
	NULL	2024-01-20
✅ Expected SQL Answer
*/
WITH ranked AS (
    SELECT
        customer_id,
        email,
        phone,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY updated_at DESC
        ) AS rn
    FROM customers_raw
),
email_survivor AS (
    SELECT
        customer_id,
        email
    FROM (
        SELECT
            customer_id,
            email,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY updated_at DESC
            ) AS rn
        FROM customers_raw
        WHERE email IS NOT NULL
    ) e
    WHERE rn = 1
),
phone_survivor AS (
    SELECT
        customer_id,
        phone
    FROM (
        SELECT
            customer_id,
            phone,
            ROW_NUMBER() OVER (
                PARTITION BY customer_id
                ORDER BY updated_at DESC
            ) AS rn
        FROM customers_raw
        WHERE phone IS NOT NULL
    ) p
    WHERE rn = 1
)
SELECT
    r.customer_id,
    e.email,
    p.phone,
    r.updated_at AS last_updated
FROM ranked r
LEFT JOIN email_survivor e ON r.customer_id = e.customer_id
LEFT JOIN phone_survivor p ON r.customer_id = p.customer_id
WHERE r.rn = 1
ORDER BY r.customer_id;
