/*
📌 Challenge 2.0 — Day 37: "Customer Support Ticket Escalation Chain"

Scenario:
You're a Data Analyst at a SaaS company's support team. Tickets can get reassigned multiple times before resolution (agent → senior agent → manager, etc.). Ops wants to measure how many handoffs each ticket went through and flag tickets that ping-ponged excessively (4+ reassignments) as a process failure worth investigating.

Table: ticket_events

Column	Type
event_id	INT
ticket_id	INT
agent_id	INT
event_time	TIMESTAMP
event_type	VARCHAR

(A ticket can have multiple 'assigned' events as it gets reassigned; exactly one 'resolved' event at the end, if resolved.)

Task: For each ticket, count the number of reassignments (an 'assigned' event where the agent_id differs from the previous 'assigned' event's agent — the very first assignment doesn't count as a reassignment). Output ticket_id, total_assignments, reassignment_count, is_excessive (reassignment_count >= 4).
*/
WITH assignments AS (
    SELECT 
        ticket_id,
        agent_id,
        event_time,
        LAG(agent_id) OVER (
            PARTITION BY ticket_id 
            ORDER BY event_time
        ) AS prev_agent_id
    FROM ticket_events
    WHERE event_type = 'assigned'
),
flagged AS (
    SELECT 
        ticket_id,
        agent_id,
        CASE 
            WHEN prev_agent_id IS NULL THEN 0        -- first assignment, not a reassignment
            WHEN agent_id != prev_agent_id THEN 1    -- genuinely different agent
            ELSE 0                                    -- same agent re-logged, not a real handoff
        END AS is_reassignment
    FROM assignments
)
SELECT 
    ticket_id,
    COUNT(*) AS total_assignments,
    SUM(is_reassignment) AS reassignment_count,
    CASE 
        WHEN SUM(is_reassignment) >= 4 THEN 'YES'
        ELSE 'NO'
    END AS is_excessive
FROM flagged
GROUP BY ticket_id
ORDER BY reassignment_count DESC;
