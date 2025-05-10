/*
🧠 Challenge: Detect Missing Dates per User
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)
/*
🎯 Your Task:
For each user, identify the gaps in their login activity where they did not log in for more than 1 day.
For each gap, return:

user_id

gap_start_date (the day after the last login)

gap_end_date (the day before the next login)

gap_length_days
*/
--Query
with Nextlogin(
    select user_id,
    login_date,
    lead(login_date) over(partition by user_id order by login_date) as next_login
    from UserLogins
),
Gaps as(
    select user_id,
        DATE_ADD(login_date, INTERVAL 1 DAY) AS gap_start_date,
        DATE_SUB(next_login, INTERVAL 1 DAY) AS gap_end_date,
        DATEDIFF(next_login, login_date) - 1 AS gap_length_days
    FROM LoginWithNext
    WHERE DATEDIFF(next_login, login_date) > 1
)
SELECT * FROM Gaps;
