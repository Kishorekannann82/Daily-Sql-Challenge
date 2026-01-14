/*
Find the Shortest Path Between Nodes (Graph BFS in SQL)
Scenario

You store a directed graph as edges:

edges

from_node	to_node	cost
A	B	1
A	C	4
B	C	2
B	D	5
C	D	1
D	E	3
C	E	7
❓ Goal

Find the shortest path from node A to node E.

Return:

start_node

end_node

total_cost

path

✅ Expected SQL Answer

(Works in PostgreSQL / SQL Server / MySQL 8+)
*/
WITH RECURSIVE paths AS (
    -- Start from A
    SELECT
        'A' AS start_node,
        'A' AS current_node,
        CAST('A' AS CHAR(100)) AS path,
        0 AS total_cost
    UNION ALL
    -- Extend paths
    SELECT
        p.start_node,
        e.to_node AS current_node,
        CONCAT(p.path, ' -> ', e.to_node) AS path,
        p.total_cost + e.cost AS total_cost
    FROM paths p
    JOIN edges e
      ON p.current_node = e.from_node
    WHERE p.path NOT LIKE CONCAT('%', e.to_node, '%') -- prevent cycles
),
ranked AS (
    SELECT
        start_node,
        current_node,
        path,
        total_cost,
        ROW_NUMBER() OVER (
            PARTITION BY current_node
            ORDER BY total_cost
        ) AS rn
    FROM paths
)
SELECT
    start_node,
    current_node AS end_node,
    total_cost,
    path
FROM ranked
WHERE current_node = 'E'
  AND rn = 1;