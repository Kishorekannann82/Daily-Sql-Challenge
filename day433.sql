/*
📌 Challenge 2.0 — Day 39: "Survey Response Rate with Skipped Questions"

Scenario:
You're a Data Analyst at a market research firm. A survey has multiple questions, but respondents can skip questions. The client wants to know the completion rate per question (what % of people who started the survey actually answered each question), and flag questions with an unusually high drop-off compared to the question right before them.

Table: survey_responses

Column	Type
response_id	INT
respondent_id	INT
question_id	INT
question_order	INT
answer_text	VARCHAR (NULL if skipped)

Task: For each question_id, calculate the number of respondents who answered it (answer_text IS NOT NULL) and the completion_rate (as a % of total respondents who started the survey). Then calculate drop_off_pct — the percentage-point drop compared to the previous question in sequence. Flag high_dropoff where the drop exceeds 15 percentage points. Output question_id, question_order, answered_count, completion_rate, drop_off_pct, high_dropoff.
*/
WITH total_respondents AS (
    SELECT COUNT(DISTINCT respondent_id) AS total_started
    FROM survey_responses
),
question_stats AS (
    SELECT 
        question_id,
        question_order,
        COUNT(DISTINCT CASE WHEN answer_text IS NOT NULL THEN respondent_id END) AS answered_count
    FROM survey_responses
    GROUP BY question_id, question_order
),
with_rate AS (
    SELECT 
        qs.question_id,
        qs.question_order,
        qs.answered_count,
        ROUND(qs.answered_count * 100.0 / tr.total_started, 2) AS completion_rate
    FROM question_stats qs
    CROSS JOIN total_respondents tr
),
with_dropoff AS (
    SELECT 
        question_id,
        question_order,
        answered_count,
        completion_rate,
        LAG(completion_rate) OVER (ORDER BY question_order) AS prev_completion_rate
    FROM with_rate
)
SELECT 
    question_id,
    question_order,
    answered_count,
    completion_rate,
    ROUND(prev_completion_rate - completion_rate, 2) AS drop_off_pct,
    CASE 
        WHEN prev_completion_rate IS NOT NULL 
             AND (prev_completion_rate - completion_rate) > 15 
        THEN 'YES'
        ELSE 'NO'
    END AS high_dropoff
FROM with_dropoff
ORDER BY question_order;
