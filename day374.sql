/*
Find tickets that were closed but reopened more than once
You work at a customer support platform like Zendesk. Each ticket goes through status changes. A ticket reopened means it was closed and then moved back to open. Find tickets that were reopened more than once — these indicate unresolved issues that frustrate customers. Return ticket_id, times_reopened, and final_status.
Table: ticket_events
event_id	ticket_id	status	event_time
1	T01	open	2024-06-01 09:00
2	T01	closed	2024-06-01 10:00
3	T01	open	2024-06-01 11:00
4	T01	closed	2024-06-01 12:00
5	T01	open	2024-06-01 13:00
6	T01	closed	2024-06-01 14:00
7	T02	open	2024-06-01 09:00
8	T02	closed	2024-06-01 10:30
9	T02	open	2024-06-01 11:30
10	T02	closed	2024-06-01 15:00
11	T03	open	2024-06-01 08:00
12	T03	closed	2024-06-01 09:00
Expected output
ticket_id	times_reopened	final_status
T01	2	closed
T01 → open→closed→open→closed→open→closed → reopened 2 times ✅ included
T02 → open→closed→open→closed → reopened 1 time ❌ not more than once
T03 → open→closed → never reopened ❌
*/
WITH with_prev AS (
  SELECT
    ticket_id,
    status,
    event_time,
    LAG(status) OVER (
      PARTITION BY ticket_id
      ORDER BY event_time
    ) AS prev_status,
    ROW_NUMBER() OVER (
      PARTITION BY ticket_id
      ORDER BY event_time DESC
    ) AS rn_desc
  FROM ticket_events
),
reopen_counts AS (
  SELECT
    ticket_id,
    SUM(CASE WHEN status = 'open'
              AND prev_status = 'closed'
              THEN 1 ELSE 0 END) AS times_reopened,
    MAX(CASE WHEN rn_desc = 1
              THEN status END)       AS final_status
  FROM with_prev
  GROUP BY ticket_id
)
SELECT
  ticket_id,
  times_reopened,
  final_status
FROM reopen_counts
WHERE times_reopened > 1
ORDER BY times_reopened DESC;
