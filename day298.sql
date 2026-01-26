/*
Calculate Node Influence Using Iterative PageRank Logic
Scenario

You have a directed graph of interactions.

edges

from_node	to_node
A	B
A	C
B	C
C	A
C	D
D	C

📌 Goal
Compute node influence score (simplified PageRank):

Start with equal rank for all nodes

Distribute rank equally across outgoing edges

Perform 3 iterations

Damping factor = 0.85

❓ Output

Return:

node

rank_after_3_iterations

✅ Expected SQL Answer

(PostgreSQL / SQL Server / MySQL 8+ — using recursive CTE)
*/
WITH RECURSIVE
nodes AS (
    SELECT DISTINCT from_node AS node FROM edges
    UNION
    SELECT DISTINCT to_node FROM edges
),
out_degree AS (
    SELECT
        from_node AS node,
        COUNT(*) AS out_cnt
    FROM edges
    GROUP BY from_node
),
initial_rank AS (
    SELECT
        node,
        1.0 / (SELECT COUNT(*) FROM nodes) AS rank,
        1 AS iteration
    FROM nodes
),
pagerank AS (
    -- iteration 1
    SELECT * FROM initial_rank

    UNION ALL

    -- next iterations
    SELECT
        n.node,
        0.15 / (SELECT COUNT(*) FROM nodes)
        + 0.85 * SUM(pr.rank / od.out_cnt) AS rank,
        pr.iteration + 1
    FROM pagerank pr
    JOIN edges e
        ON pr.node = e.from_node
    JOIN out_degree od
        ON e.from_node = od.node
    JOIN nodes n
        ON e.to_node = n.node
    WHERE pr.iteration < 3
    GROUP BY n.node, pr.iteration
)
SELECT
    node,
    ROUND(rank, 4) AS rank_after_3_iterations
FROM pagerank
WHERE iteration = 3
ORDER BY rank_after_3_iterations DESC;