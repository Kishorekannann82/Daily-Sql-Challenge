/*
Challenge 2.0 — Day 4: "Running Total with a Twist — Monthly Budget Burn"

Scenario:
You're supporting a finance team that tracks company expenses. They want to monitor cumulative spend per department per month, and flag the exact transaction where each department crosses its monthly budget for the first time.

Table: expenses

Column	Type
expense_id	INT
department	VARCHAR
expense_date	DATE
amount	DECIMAL

Table: budgets

Column	Type
department	VARCHAR
month	INT
year	INT
monthly_budget	DECIMAL

Task: For each department and month, calculate the running total of expenses ordered by expense_date, and identify the first transaction where the running total exceeds the monthly budget. Output department, expense_date, amount, running_total, monthly_budget.

✅ Solution
sql
*/
WITH monthly_expenses AS (
    SELECT 
        e.department,
        e.expense_date,
        e.amount,
        EXTRACT(MONTH FROM e.expense_date) AS month,
        EXTRACT(YEAR FROM e.expense_date) AS year,
        SUM(e.amount) OVER (
            PARTITION BY e.department, 
                         EXTRACT(YEAR FROM e.expense_date), 
                         EXTRACT(MONTH FROM e.expense_date)
            ORDER BY e.expense_date, e.expense_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total
    FROM expenses e
),
flagged AS (
    SELECT 
        me.department,
        me.expense_date,
        me.amount,
        me.running_total,
        b.monthly_budget,
        ROW_NUMBER() OVER (
            PARTITION BY me.department, me.year, me.month
            ORDER BY me.expense_date
        ) AS breach_rank
    FROM monthly_expenses me
    JOIN budgets b
        ON me.department = b.department
        AND me.month = b.month
        AND me.year = b.year
    WHERE me.running_total > b.monthly_budget
)
SELECT 
    department,
    expense_date,
    amount,
    running_total,
    monthly_budget
FROM flagged
WHERE breach_rank = 1
ORDER BY department, expense_date;
