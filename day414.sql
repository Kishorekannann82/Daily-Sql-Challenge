/*
Deduplicating Records with Fuzzy Priority Rules"

Scenario:
You're a Data Analyst at a CRM company. Due to a sync bug, some customer records got duplicated across multiple source systems. Data eng wants one clean row per customer, keeping the record with the most complete data — prioritized as: (1) has a verified email, (2) has a phone number, (3) most recently updated.

Table: customer_records

Column	Type
record_id	INT
customer_id	INT
email	VARCHAR (nullable)
email_verified	BOOLEAN
phone	VARCHAR (nullable)
updated_at	TIMESTAMP

Task: For each customer_id, pick the single "best" record according to the priority rules above. Output customer_id, record_id, email, phone, updated_at.
*/
WITH prioritized AS (
    SELECT 
        customer_id,
        record_id,
        email,
        phone,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY 
                CASE WHEN email_verified = TRUE THEN 1 ELSE 0 END DESC,
                CASE WHEN phone IS NOT NULL AND phone != '' THEN 1 ELSE 0 END DESC,
                updated_at DESC
        ) AS priority_rank
    FROM customer_records
)
SELECT 
    customer_id,
    record_id,
    email,
    phone,
    updated_at
FROM prioritized
WHERE priority_rank = 1
ORDER BY customer_id;
