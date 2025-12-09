/*
Build State Transition Probabilities (Markov Chain)
Scenario

You track user behavior states over time:

user_states

user_id	state	state_time
101	Active	2024-01-01 09:00:00
101	Browsing	2024-01-01 09:10:00
101	Purchasing	2024-01-01 09:20:00
101	Active	2024-01-02 10:00:00
102	Browsing	2024-01-03 11:00:00
102	Active	2024-01-03 11:30:00
102	Browsing	2024-01-03 11:40:00
103	Active	2024-01-04 08:00:00
103	Churned	2024-01-04 09:00:00
❓Goal:

Compute transition probabilities between states.
Example:

Active → Browsing

Browsing → Purchasing

Active → Churned
etc.

Final Output
from_state	to_state	transitions	probability
Active	Browsing	3	0.42
Browsing	Purchasing	1	0.14
…	…	…	…

✔ Probabilities = transitions_out_of_state / total_transitions_for_state

✅ Expected SQL Answer

(Works in Postgres, SQL Server, MySQL 8+)
*/

WITH ordered AS (
    SELECT
        user_id,
        state AS from_state,
        LEAD(state) OVER (
            PARTITION BY user_id
            ORDER BY state_time
        ) AS to_state
    FROM user_states
),
valid_trans AS (
    SELECT
        from_state,
        to_state
    FROM ordered
    WHERE to_state IS NOT NULL
),
counts AS (
    SELECT
        from_state,
        to_state,
        COUNT(*) AS transitions
    FROM valid_trans
    GROUP BY from_state, to_state
),
totals AS (
    SELECT
        from_state,
        SUM(transitions) AS total_out
    FROM counts
    GROUP BY from_state
)
SELECT
    c.from_state,
    c.to_state,
    c.transitions,
    ROUND(c.transitions * 1.0 / t.total_out, 2) AS probability
FROM counts c
JOIN totals t ON c.from_state = t.from_state
ORDER BY c.from_state, c.to_state;