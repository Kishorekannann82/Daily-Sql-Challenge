/*
You work at a B2B SaaS company. The sales team tracks leads through a funnel: lead → qualified → proposal → closed. For each stage, find the count of deals, the drop-off count to the next stage, and the conversion rate % to the next stage. Return stage, total, moved_to_next, and conversion_rate.
Table: deals
deal_id	stage	deal_date
D01	lead	2024-01-01
D02	lead	2024-01-02
D03	lead	2024-01-03
D04	lead	2024-01-04
D05	lead	2024-01-05
D06	qualified	2024-01-06
D07	qualified	2024-01-07
D08	qualified	2024-01-08
D09	proposal	2024-01-09
D10	proposal	2024-01-10
D11	closed	2024-01-11
Expected output
stage	total	moved_to_next	conversion_rate
lead	5	3	60.0
qualified	3	2	66.7
proposal	2	1	50.0
closed	1	NULL	NULL
lead(5) → qualified(3): 3 moved on, 60.0% conversion
qualified(3) → proposal(2): 2 moved on, 66.7% conversion
proposal(2) → closed(1): 1 moved on, 50.0% conversion
closed(1) → no next stage: NULL NULL
Hint
Next problem ↗
Answer
*/
WITH stage_counts AS (
  SELECT
    stage,
    COUNT(*) AS total,
    CASE stage
      WHEN 'lead'      THEN 1
      WHEN 'qualified' THEN 2
      WHEN 'proposal'  THEN 3
      WHEN 'closed'    THEN 4
    END AS stage_order
  FROM deals
  GROUP BY stage
),
with_next AS (
  SELECT
    stage,
    total,
    stage_order,
    LEAD(total) OVER (
      ORDER BY stage_order
    ) AS moved_to_next
  FROM stage_counts
)
SELECT
  stage,
  total,
  moved_to_next,
  ROUND(
    moved_to_next * 100.0 / NULLIF(total, 0)
  , 1) AS conversion_rate
FROM with_next
ORDER BY stage_order;