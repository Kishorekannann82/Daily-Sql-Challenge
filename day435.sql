/*
📌 Challenge 2.0 — Day 41: "Employee Shift Overlap and Coverage Gaps"

Scenario:
You're a Data Analyst at a call center. Ops wants two things from the shift schedule: (1) any time gaps during the day where zero agents are covering, and (2) the maximum number of agents working simultaneously at any point (for staffing cost analysis).

Table: shifts

Column	Type
shift_id	INT
agent_id	INT
shift_start	TIMESTAMP
shift_end	TIMESTAMP

Task: For a single day's shifts, find every coverage gap (a period with zero agents on duty, between the earliest shift_start and latest shift_end) and separately find the maximum concurrent agents at any point in time. Output two result sets: gaps as gap_start, gap_end; and one row with max_concurrent_agents.
*/
-- PART 1: Coverage gaps
WITH events AS (
    SELECT shift_start AS event_time, 1 AS event_type FROM shifts   -- +1 = shift begins
    UNION ALL
    SELECT shift_end AS event_time, -1 AS event_type FROM shifts    -- -1 = shift ends
),
running_coverage AS (
    SELECT 
        event_time,
        SUM(event_type) OVER (
            ORDER BY event_time, event_type DESC   -- process starts before ends at same timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS agents_on_duty
    FROM events
),
distinct_points AS (
    SELECT DISTINCT event_time, agents_on_duty
    FROM running_coverage
),
with_next AS (
    SELECT 
        event_time AS gap_start,
        LEAD(event_time) OVER (ORDER BY event_time) AS gap_end,
        agents_on_duty
    FROM distinct_points
)
SELECT 
    gap_start,
    gap_end
FROM with_next
WHERE agents_on_duty = 0
  AND gap_end IS NOT NULL
ORDER BY gap_start;

-- PART 2: Max concurrent agents
WITH events AS (
    SELECT shift_start AS event_time, 1 AS event_type FROM shifts
    UNION ALL
    SELECT shift_end AS event_time, -1 AS event_type FROM shifts
),
running_coverage AS (
    SELECT 
        event_time,
        SUM(event_type) OVER (
            ORDER BY event_time, event_type DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS agents_on_duty
    FROM events
)
SELECT MAX(agents_on_duty) AS max_concurrent_agents
FROM running_coverage;
