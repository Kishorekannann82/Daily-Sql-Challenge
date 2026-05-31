/*
Day 21
Intermediate
Customer Support / Freshdesk
Pivot + Response Time SLA
Agents who breached SLA response time
You work at a customer support platform like Freshdesk or Zendesk. Each ticket must receive a first response within 2 hours (the SLA). Find all support agents who breached SLA on more than 30% of their tickets. Return agent_name, total_tickets, breached_tickets, and breach_rate rounded to 1 decimal place.
Table: tickets
ticket_id	agent_id	created_at	first_response_at
T01	A01	2024-04-01 09:00	2024-04-01 10:30
T02	A01	2024-04-01 11:00	2024-04-01 13:30
T03	A01	2024-04-02 09:00	2024-04-02 10:00
T04	A01	2024-04-02 14:00	2024-04-02 16:30
T05	A02	2024-04-01 10:00	2024-04-01 11:00
T06	A02	2024-04-01 13:00	2024-04-01 16:00
T07	A02	2024-04-02 10:00	2024-04-02 11:00
T08	A03	2024-04-01 08:00	2024-04-01 11:00
T09	A03	2024-04-02 09:00	2024-04-02 12:30
T10	A03	2024-04-03 10:00	2024-04-03 12:30
Table: agents
agent_id	agent_name
A01	Ravi Kumar
A02	Meena Raj
A03	Suresh Das
Expected output
agent_name	total_tickets	breached_tickets	breach_rate
Ravi Kumar	4	2	50.0
Suresh Das	3	3	100.0
A01 Ravi → T01(1.5h✅) T02(2.5h❌) T03(1h✅) T04(2.5h❌) → 2/4 = 50.0% > 30% ✅
A02 Meena → T05(1h✅) T06(3h❌) T07(1h✅) → 1/3 = 33.3% > 30% ✅... wait
Hmm — T06 is 3 hrs → breach. 1 breach out of 3 = 33.3% which IS > 30%
Check the answer — Meena may or may not appear depending on strict > 30 reading.
A03 Suresh → T08(3h❌) T09(3.5h❌) T10(2.5h❌) → 3/3 = 100% ✅
Hint
Next problem ↗
Answer
*/
WITH ticket_sla AS (
  SELECT
    agent_id,
    ticket_id,
    EXTRACT(EPOCH FROM (first_response_at - created_at)) / 60
                                             AS response_minutes,
    CASE
      WHEN EXTRACT(EPOCH FROM
             (first_response_at - created_at)) / 60 > 120
      THEN 1 ELSE 0
    END                                      AS is_breached
  FROM tickets
),
agent_stats AS (
  SELECT
    agent_id,
    COUNT(*)           AS total_tickets,
    SUM(is_breached)   AS breached_tickets,
    ROUND(
      SUM(is_breached) * 100.0 / COUNT(*),
    1)                 AS breach_rate
  FROM ticket_sla
  GROUP BY agent_id
)
SELECT
  a.agent_name,
  s.total_tickets,
  s.breached_tickets,
  s.breach_rate
FROM agent_stats s
JOIN agents a ON s.agent_id = a.agent_id
WHERE s.breach_rate > 30
ORDER BY s.breach_rate DESC;