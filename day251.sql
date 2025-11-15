/*

Flatten a Hierarchy and Show Depth Levels
Scenario:

You have a categories table representing a multi-level hierarchy:

categories

category_id	category_name	parent_id
1	Electronics	NULL
2	Computers	1
3	Laptops	2
4	Ultrabooks	3
5	Desktops	2
6	Furniture	NULL
7	Chairs	6
8	Office Chairs	7
9	Gaming Chairs	7
❓Question:

Write a SQL query that flattens the hierarchy and returns:

category_id

category_name

full_path (e.g.: Electronics > Computers > Laptops > Ultrabooks)

depth_level (root = 1)

✅ Expected Answer (SQL Solution)
*/
WITH RECURSIVE category_tree AS (
    -- Start with root categories
    SELECT
        category_id,
        category_name,
        parent_id,
        category_name AS full_path,
        1 AS depth_level
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursively append subcategories
    SELECT
        c.category_id,
        c.category_name,
        c.parent_id,
        CONCAT(ct.full_path, ' > ', c.category_name) AS full_path,
        ct.depth_level + 1 AS depth_level
    FROM categories c
    INNER JOIN category_tree ct 
        ON c.parent_id = ct.category_id
)
SELECT
    category_id,
    category_name,
    full_path,
    depth_level
FROM category_tree
ORDER BY full_path;