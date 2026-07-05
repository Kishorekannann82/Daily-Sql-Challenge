/*
Find each user's top spending category
You work at CRED. The insights team wants to show each user their highest spending category this month — like "You spent most on Food 🍔". Return user_id, top_category, category_spend, and total_spend. If there's a tie, return all tied categories.
Table: transactions
txn_id	user_id	category	amount	txn_date
1	U01	Food	1200	2024-06-01
2	U01	Food	800	2024-06-05
3	U01	Travel	3500	2024-06-10
4	U01	Shopping	2000	2024-06-15
5	U02	Food	500	2024-06-02
6	U02	Entertainment	500	2024-06-08
7	U02	Shopping	1200	2024-06-12
8	U02	Shopping	300	2024-06-18
9	U03	Travel	4000	2024-06-05
10	U03	Food	600	2024-06-09
11	U03	Travel	2500	2024-06-20
Expected output
user_id	top_category	category_spend	total_spend
U01	Travel	3500	7500
U02	Shopping	1500	2500
U03	Travel	6500	7100
U01 → Food=2000, Travel=3500, Shopping=2000 → Travel wins 🏆 total=7500
U02 → Food=500, Entertainment=500, Shopping=1500 → Shopping wins 🏆 total=2500
U03 → Travel=6500, Food=600 → Travel wins 🏆 total=7100
*/
Answer
WITH cat_spend AS (
  SELECT
    user_id,
    category,
    SUM(amount) AS category_spend
  FROM transactions
  GROUP BY user_id, category
),
ranked AS (
  SELECT
    user_id,
    category,
    category_spend,
    SUM(category_spend) OVER (
      PARTITION BY user_id
    )                    AS total_spend,
    DENSE_RANK() OVER (
      PARTITION BY user_id
      ORDER BY category_spend DESC
    )                    AS rnk
  FROM cat_spend
)
SELECT
  user_id,
  category    AS top_category,
  category_spend,
  total_spend
FROM ranked
WHERE rnk = 1
ORDER BY user_id;
