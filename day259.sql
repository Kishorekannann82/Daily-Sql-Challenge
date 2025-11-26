/*
Graph Traversal With Cycle Detection & Path Output
Scenario:

You have a directed graph stored in a table:

graph_edges
from_node	to_node
A	B
B	C
C	D
D	B
C	E
E	F
X	Y

Your task is to traverse the graph and:

Requirements:

For each starting node:

Produce every possible path

Detect when a cycle occurs

Mark the path as cycle_detected = YES/NO

Stop traversal once a cycle is detected

Handle separate components (A–F chain and X–Y chain)

❓ Question:

Write a SQL query that returns:

start_node

current_node

path

cycle_detected (YES/NO)

✅ Expected SQL Answer (recursive CTE with cycle detection)
*/
WITH RECURSIVE traverse AS (
    -- Start from every unique from_node
    SELECT
        g.from_node AS start_node,
        g.from_node AS current_node,
        g.to_node,
        g.from_node || ' -> ' || g.to_node AS path,
        ARRAY[g.from_node, g.to_node] AS visited,
        FALSE AS cycle_detected
    FROM graph_edges g

    UNION ALL

    -- Recursive traversal
    SELECT
        t.start_node,
        g.from_node AS current_node,
        g.to_node,
        t.path || ' -> ' || g.to_node AS path,
        visited || g.to_node,
        g.to_node = ANY(visited) AS cycle_detected
    FROM traverse t
    JOIN graph_edges g
      ON t.to_node = g.from_node
    WHERE NOT cycle_detected   -- Stop expanding once a cycle is found
)
SELECT
    start_node,
    current_node,
    path,
    CASE WHEN cycle_detected THEN 'YES' ELSE 'NO' END AS cycle_detected
FROM traverse
ORDER BY start_node, path;