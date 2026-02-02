/*
Detect Revenue Leakage at Order Level
Scenario

You have orders and pricing rules.
Each order should generate an expected amount, but due to discounts, bugs, or missing charges, the actual billed amount may differ.

orders
order_id	product_id	quantity	billed_amount
1	A	2	180
2	B	1	95
3	A	3	300
4	C	5	225
5	B	2	180
price_list
product_id	unit_price
A	100
B	100
C	50
📌 Definitions

Expected amount = quantity × unit_price

Revenue leakage = expected_amount − billed_amount

Leakage > 0 → underbilling

Leakage < 0 → overbilling

❓ Goal

Identify orders with revenue leakage and summarize:

Return:

order_id

product_id

expected_amount

billed_amount

leakage_amount

leakage_type (UNDERBILLED / OVERBILLED / OK)

✅ Expected SQL Answer

(Works in MySQL 8+, Postgres, SQL Server)
*/
SELECT
    o.order_id,
    o.product_id,
    o.quantity * p.unit_price AS expected_amount,
    o.billed_amount,
    (o.quantity * p.unit_price - o.billed_amount) AS leakage_amount,
    CASE
        WHEN o.quantity * p.unit_price > o.billed_amount
            THEN 'UNDERBILLED'
        WHEN o.quantity * p.unit_price < o.billed_amount
            THEN 'OVERBILLED'
        ELSE 'OK'
    END AS leakage_type
FROM orders o
JOIN price_list p
  ON o.product_id = p.product_id
ORDER BY o.order_id;