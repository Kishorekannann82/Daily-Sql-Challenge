/*
🧠 Challenge: Find Missing Dates in a Sequence
🗃️ Table:
Sales (
  sale_id INT,
  sale_date DATE,
  amount DECIMAL(10,2)
)

🎯 Task:

Find all missing dates in January 2023 where no sales were recorded.

✅ Example Data:
sale_id	sale_date	amount
1	2023-01-01	100.00
2	2023-01-02	150.00
3	2023-01-04	200.00
4	2023-01-07	300.00
✅ Expected Output:
missing_date
2023-01-03
2023-01-05
2023-01-06
2023-01-08
... (until 2023-01-31 if missing)
✅ MySQL Answer (Using Recursive CTE):
*/

WITH RECURSIVE AllDates AS (
    SELECT DATE('2023-01-01') AS dt
    UNION ALL
    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM AllDates
    WHERE dt < '2023-01-31'
)
SELECT dt AS missing_date
FROM AllDates
LEFT JOIN Sales s ON s.sale_date = AllDates.dt
WHERE s.sale_date IS NULL;

