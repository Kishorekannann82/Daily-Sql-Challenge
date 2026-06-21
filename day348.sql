/*
Find products that went out of stock
You work at a quick-commerce warehouse like Zepto. Each product has stock movements — restock (adds units) and sale (removes units). Find all products where the running stock level dropped to zero or below at any point. Return product_name, movement_date, and running_stock at the moment it went out of stock (first occurrence only).
Table: stock_movements
movement_id	product_name	movement_date	type	qty
1	Milk 1L	2024-05-01	restock	50
2	Milk 1L	2024-05-01	sale	20
3	Milk 1L	2024-05-02	sale	35
4	Milk 1L	2024-05-03	restock	40
5	Bread	2024-05-01	restock	30
6	Bread	2024-05-02	sale	10
7	Bread	2024-05-03	sale	15
8	Eggs	2024-05-01	restock	100
9	Eggs	2024-05-02	sale	40
10	Eggs	2024-05-03	sale	30
Expected output
product_name	movement_date	running_stock
Milk 1L	2024-05-02	-5
Milk 1L → +50 → -20 = 30 → -35 = -5 ❌ went out of stock on May 2 → +40 = 35
Bread → +30 → -10 = 20 → -15 = 5 → never goes below 0 ✅ fine
Eggs → +100 → -40 = 60 → -30 = 30 → never goes below 0 ✅ fine
*/
WITH signed_moves AS (
  SELECT
    product_name,
    movement_date,
    CASE
      WHEN type = 'restock' THEN  qty
      WHEN type = 'sale'    THEN -qty
    END AS signed_qty
  FROM stock_movements
),
running AS (
  SELECT
    product_name,
    movement_date,
    SUM(signed_qty) OVER (
      PARTITION BY product_name
      ORDER BY movement_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_stock
  FROM signed_moves
),
first_stockout AS (
  SELECT
    product_name,
    movement_date,
    running_stock,
    ROW_NUMBER() OVER (
      PARTITION BY product_name
      ORDER BY movement_date
    ) AS rn
  FROM running
  WHERE running_stock <= 0
)
SELECT
  product_name,
  movement_date,
  running_stock
FROM first_stockout
WHERE rn = 1
ORDER BY product_name;
