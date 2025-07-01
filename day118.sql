/*
🧠 Challenge: Days Between Consecutive Logins
🗃️ Table: UserLogins
*/
UserLogins (
    user_id INT,
    login_date DATE
)
/*
🎯 Your Task:
For each user, calculate the number of days between each of their consecutive logins. Output:

user_id

login_date (current login)

previous_login

days_since_last_login

*/
with LoginwithPrevious as (
    select user_id,
    login_date,
    lag(login_date) over(partition by user_id order by login_date) as previous_login
    from UserLogins
)
select user_id,
login_date,
previous_login,
datediff(login_date,previous_login) as days_since_last_login
from LoginwithPrevious
WHERE previous_login is not null;