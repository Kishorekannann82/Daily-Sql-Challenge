/*
Find students who improved their score on every re-attempt
You work at an LMS platform. Students can attempt a quiz multiple times. Find students who improved their score on every single attempt compared to the previous one — a perfect improvement streak. Return student_name, total_attempts, first_score, latest_score, and total_improvement. Only include students with at least 2 attempts.
Table: quiz_attempts
attempt_id	student_name	attempt_no	score
1	Arun	1	45
2	Arun	2	62
3	Arun	3	78
4	Arun	4	91
5	Bala	1	55
6	Bala	2	70
7	Bala	3	65
8	Chitra	1	80
9	Chitra	2	85
10	Deepa	1	40
Expected output
student_name	total_attempts	first_score	latest_score	total_improvement
Arun	4	45	91	46
Chitra	2	80	85	5
Arun → 45→62→78→91: every attempt improved ✅ perfect streak
Bala → 55→70→65: dropped on attempt 3 ❌ not a perfect streak
Chitra → 80→85: 2 attempts, improved ✅
Deepa → only 1 attempt ❌ needs at least 2
*/
WITH with_prev AS (
  SELECT
    student_name,
    attempt_no,
    score,
    LAG(score) OVER (
      PARTITION BY student_name
      ORDER BY attempt_no
    ) AS prev_score
  FROM quiz_attempts
),
streak_check AS (
  SELECT
    student_name,
    COUNT(*)                                           AS total_attempts,
    MIN(score)                                         AS first_score,
    MAX(score)                                         AS latest_score,
    MAX(score) - MIN(score)                            AS total_improvement,
    -- count non-first attempts where score improved
    SUM(CASE WHEN prev_score IS NOT NULL
              AND score > prev_score THEN 1 ELSE 0 END) AS improved_count,
    SUM(CASE WHEN prev_score IS NOT NULL
              THEN 1 ELSE 0 END)                        AS comparable_attempts
  FROM with_prev
  GROUP BY student_name
)
SELECT
  student_name,
  total_attempts,
  first_score,
  latest_score,
  total_improvement
FROM streak_check
WHERE
  total_attempts >= 2
  AND improved_count = comparable_attempts
ORDER BY total_improvement DESC;
