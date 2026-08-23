/*
"First and Last Purchase Attribution"

Scenario:
You're a Data Analyst at a marketing agency running multi-touch attribution. For every converted customer, the client wants to know which marketing channel drove the first touch (first-click attribution) and which drove the last touch before purchase (last-click attribution) — both from the same click stream.

Table: clicks

Column	Type
click_id	INT
customer_id	INT
channel	VARCHAR
click_time	TIMESTAMP

Table: purchases

Column	Type
purchase_id	INT
customer_id	INT
purchase_time	TIMESTAMP

Task: For each purchase, find the first channel the customer ever clicked (before that purchase) and the last channel they clicked (immediately before that purchase, i.e. the most recent click strictly before purchase_time). Output purchase_id, customer_id, purchase_time, first_touch_channel, last_touch_channel.
*/
WITH relevant_clicks AS (
    SELECT 
        p.purchase_id,
        p.customer_id,
        p.purchase_time,
        c.channel,
        c.click_time,
        ROW_NUMBER() OVER (
            PARTITION BY p.purchase_id 
            ORDER BY c.click_time ASC
        ) AS first_rank,
        ROW_NUMBER() OVER (
            PARTITION BY p.purchase_id 
            ORDER BY c.click_time DESC
        ) AS last_rank
    FROM purchases p
    JOIN clicks c 
        ON p.customer_id = c.customer_id
        AND c.click_time < p.purchase_time      -- only clicks before this purchase
)
SELECT 
    rc_first.purchase_id,
    rc_first.customer_id,
    rc_first.purchase_time,
    rc_first.channel AS first_touch_channel,
    rc_last.channel AS last_touch_channel
FROM relevant_clicks rc_first
JOIN relevant_clicks rc_last
    ON rc_first.purchase_id = rc_last.purchase_id
WHERE rc_first.first_rank = 1
  AND rc_last.last_rank = 1
ORDER BY rc_first.purchase_id;
