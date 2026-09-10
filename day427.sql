/*
📌 Challenge 2.0 — Day 33: "Multi-Level Category Rollup — Sales by Category Tree"

Scenario:
You're a Data Analyst at a retail company. Products belong to a hierarchical category tree (e.g., Electronics → Phones → Smartphones). Finance wants total sales rolled up at every level of the hierarchy — so sales of "Smartphones" should also count toward "Phones" and "Electronics" totals.

Table: categories

Column	Type
category_id	INT
category_name	VARCHAR
parent_category_id	INT (NULL for top-level)

Table: sales

Column	Type
sale_id	INT
category_id	INT
revenue	DECIMAL

Task: Output category_id, category_name, level, total_revenue — where total_revenue for any category includes its own direct sales plus all sales from every descendant category beneath it, no matter how deep.
*/
WITH RECURSIVE category_tree AS (
    -- Anchor: every category paired with itself (depth 0 = itself)
    SELECT 
        category_id AS ancestor_id,
        category_id AS descendant_id,
        category_name,
        0 AS level
    FROM categories

    UNION ALL

    -- Recursive step: walk down to children, tagging them with their ancestor
    SELECT 
        ct.ancestor_id,
        c.category_id AS descendant_id,
        c.category_name,
        ct.level + 1
    FROM categories c
    JOIN category_tree ct 
        ON c.parent_category_id = ct.descendant_id
),
rollup AS (
    SELECT 
        ct.ancestor_id AS category_id,
        SUM(COALESCE(s.revenue, 0)) AS total_revenue
    FROM category_tree ct
    LEFT JOIN sales s 
        ON ct.descendant_id = s.category_id
    GROUP BY ct.ancestor_id
)
SELECT 
    c.category_id,
    c.category_name,
    (SELECT MIN(level) FROM category_tree WHERE ancestor_id = c.category_id AND descendant_id = c.category_id) AS level,
    r.total_revenue
FROM categories c
JOIN rollup r 
    ON c.category_id = r.category_id
ORDER BY c.category_id;
