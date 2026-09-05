/*
📌 Challenge 2.0 — Day 29: "Pathing Analysis — Most Common Next Page"

Scenario:
You're a Data Analyst at an e-commerce site. UX wants to understand navigation behavior: for every page, what's the most common next page users visit immediately after? This feeds a "suggested next step" feature.

Table: page_visits

Column	Type
visit_id	INT
user_id	INT
page_url	VARCHAR
visit_time	TIMESTAMP

(Assume visits are already scoped to a single session — no need to handle session boundaries here.)

Task: For each page_url, find the single most frequent next page visited immediately after it (by the same user, next visit_time). Output current_page, next_page, transition_count, rank. If there's a tie for most common next page, show all tied pages.
*/
WITH ordered AS (
    SELECT 
        user_id,
        page_url AS current_page,
        LEAD(page_url) OVER (
            PARTITION BY user_id 
            ORDER BY visit_time
        ) AS next_page
    FROM page_visits
),
transitions AS (
    SELECT 
        current_page,
        next_page,
        COUNT(*) AS transition_count
    FROM ordered
    WHERE next_page IS NOT NULL   -- excludes the last page in each user's sequence
    GROUP BY current_page, next_page
),
ranked AS (
    SELECT 
        current_page,
        next_page,
        transition_count,
        RANK() OVER (
            PARTITION BY current_page 
            ORDER BY transition_count DESC
        ) AS rank
    FROM transitions
)
SELECT 
    current_page,
    next_page,
    transition_count,
    rank
FROM ranked
WHERE rank = 1
ORDER BY current_page, next_page;
