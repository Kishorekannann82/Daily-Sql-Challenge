/*
Bill of Materials (BOM) Recursive Explosion With Cost Roll-Up

This is VERY ADVANCED — used in ERP, inventory, and manufacturing systems.

📦 Scenario:

You have a Bill of Materials where products are made of components, which may themselves have sub-components.

bom (Bill of Materials)
parent_item	child_item	quantity
A	B	2
A	C	1
B	D	3
B	E	2
C	F	4
E	G	5
item_costs
item	unit_cost
B	10
C	12
D	3
E	4
F	2
G	1

🔍 Goal
Compute the total cost to manufacture item A, including all subcomponents recursively, multiplied by required quantities.

🎯 Expected Output
root_item	child_item	total_quantity	total_cost
A	B	2	20
A	C	1	12
A	D	6	18
A	E	4	16
A	F	4	8
A	G	20	20
	TOTAL COST OF A		94
✅ SQL Solution (Recursive CTE)

Works in PostgreSQL, SQL Server, MySQL 8+
*/
WITH RECURSIVE explode AS (
    -- Level 1 components of A
    SELECT
        parent_item AS root_item,
        child_item,
        quantity AS qty,
        quantity AS total_qty
    FROM bom
    WHERE parent_item = 'A'

    UNION ALL

    -- Recursively expand sub-components
    SELECT
        e.root_item,
        b.child_item,
        b.quantity,
        e.total_qty * b.quantity AS total_qty
    FROM explode e
    JOIN bom b
        ON e.child_item = b.parent_item
),
costs AS (
    SELECT
        root_item,
        child_item,
        total_qty,
        ic.unit_cost,
        total_qty * ic.unit_cost AS total_cost
    FROM explode
    JOIN item_costs ic ON ic.item = explode.child_item
)
SELECT *
FROM costs
ORDER BY child_item;

-- To compute total cost for A
SELECT SUM(total_cost) AS total_manufacturing_cost_A
FROM costs;