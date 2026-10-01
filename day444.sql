/*
📌 Challenge 2.0 — Day 49: "Market Basket — Sequential Purchase Patterns (Next Likely Purchase)"

Scenario:
You're a Data Analyst at an online pharmacy. Unlike basket analysis (same order), the product team wants sequential patterns across separate orders over time — e.g., "customers who buy Product A tend to buy Product B in their next order, within 60 days." This powers a "you might need this soon" reminder email.

Table: orders

Column	Type
order_id	INT
customer_id	INT
order_date	DATE

Table: order_items

Column	Type
order_id	INT
product_id	INT

Task: For every product a customer buys, find the product(s) they bought in their very next order (if that next order happened within 60 days). Aggregate across all customers to find the top sequential pairs. Output product_a, product_b, sequence_count, rank (top 15 pairs overall).
*/
WITH customer_orders AS (
    SELECT 
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id ORDER BY order_date, order_id
        ) AS order_seq
    FROM orders
),
order_pairs AS (
    -- Pair each order with the customer's immediately following order (if within 60 days)
    SELECT 
        o1.customer_id,
        o1.order_id AS order_a,
        o2.order_id AS order_b
    FROM customer_orders o1
    JOIN customer_orders o2 
        ON o1.customer_id = o2.customer_id
        AND o2.order_seq = o1.order_seq + 1       -- strictly the NEXT order, not just any later one
        AND o2.order_date <= o1.order_date + INTERVAL '60 days'
),
product_sequences AS (
    SELECT DISTINCT
        oi1.product_id AS product_a,
        oi2.product_id AS product_b
    FROM order_pairs op
    JOIN order_items oi1 ON op.order_a = oi1.order_id
    JOIN order_items oi2 ON op.order_b = oi2.order_id
    WHERE oi1.product_id != oi2.product_id   -- exclude trivial self-pairs (rebuying same product)
),
sequence_counts AS (
    SELECT 
        product_a,
        product_b,
        COUNT(*) AS sequence_count
    FROM product_sequences
    GROUP BY product_a, product_b
),
ranked AS (
    SELECT 
        product_a,
        product_b,
        sequence_count,
        RANK() OVER (ORDER BY sequence_count DESC) AS rank
    FROM sequence_counts
)
SELECT *
FROM ranked
WHERE rank <= 15
ORDER BY rank;
