/*
Find Full Category Hierarchy (Parent → Subcategory → Sub-subcategory)

Scenario:
You have a table called categories representing a category tree:

category_id	category_name	parent_id
1	Electronics	NULL
2	Computers	1
3	Laptops	2
4	Desktops	2
5	Accessories	1
6	Mice	5
7	Keyboards	5
8	Furniture	NULL
9	Chairs	8
10	Tables	8
❓Question:

Write a SQL query to produce the full category hierarchy path
(e.g., Electronics > Computers > Laptops) for all categories.

Return:

category_id

category_name

full_path

✅ Expected Answer (SQL Solution)
*/
WITH RECURSIVE category_hierarchy AS (
    -- Base case: top-level categories
    SELECT 
        category_id,
        category_name,
        parent_id,
        category_name AS full_path
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive step: attach subcategories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_id,
        CONCAT(ch.full_path, ' > ', c.category_name) AS full_path
    FROM categories c
    INNER JOIN category_hierarchy ch 
        ON c.parent_id = ch.category_id
)
SELECT 
    category_id,
    category_name,
    full_path
FROM category_hierarchy
ORDER BY full_path;