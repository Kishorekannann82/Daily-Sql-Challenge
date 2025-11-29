/*
Compute Fraud Score Using Weighted Metrics
Scenario

You monitor transaction behavior, and you assign different risk weights:

Metric	Column	Risk Weight
Amount above $1000	amount	0.5
High-risk country	country	0.3
More than 3 transactions same day	txn_count_day	0.2
Data Table

transactions

txn_id	user_id	txn_date	amount	country
1	101	2024-01-01	900	US
2	101	2024-01-01	1100	US
3	101	2024-01-01	1200	CA
4	102	2024-01-05	200	MX
5	102	2024-01-05	5000	RU
6	103	2024-01-10	800	US

High-risk countries: ('CA','RU','NG','PK','IR','KP','AF')

❓ Question

Compute a fraud score per transaction:

fraud_score =
  0.5 * (amount > 1000 ? 1 : 0)
+ 0.3 * (country in high-risk list ? 1 : 0)
+ 0.2 * (txn_count_day > 3 ? 1 : 0)


Return:

txn_id

user_id

amount

txn_count_day

fraud_score

fraud_flag (YES if score >= 0.5 else NO)

✅ Expected SQL Answer
*/
WITH daily_counts AS (
    SELECT
        txn_id,
        user_id,
        amount,
        country,
        txn_date,
        COUNT(*) OVER (
            PARTITION BY user_id, txn_date
        ) AS txn_count_day
    FROM transactions
),
scored AS (
    SELECT
        txn_id,
        user_id,
        amount,
        country,
        txn_date,
        txn_count_day,
        (
            0.5 * CASE WHEN amount > 1000 THEN 1 ELSE 0 END +
            0.3 * CASE WHEN country IN ('CA','RU','NG','PK','IR','KP','AF') THEN 1 ELSE 0 END +
            0.2 * CASE WHEN txn_count_day > 3 THEN 1 ELSE 0 END
        ) AS fraud_score
    FROM daily_counts
)
SELECT
    txn_id,
    user_id,
    amount,
    txn_count_day,
    ROUND(fraud_score, 2) AS fraud_score,
    CASE WHEN fraud_score >= 0.5 THEN 'YES' ELSE 'NO' END AS fraud_flag
FROM scored
ORDER BY fraud_score DESC;
