/*
🧠 Challenge: Most Active Users per Month
🗃️ Table: Logins
*/
Logins (
    user_id INT,
    login_date DATE
)
/* 🎯 Your Task:
For each month, find the user who logged in the most times.
If there is a tie, you can return any one of the top users for that month.

✅ Expected Output Example:
month	user_id	login_count
2024-05	1	10
2024-06	2	8
*/
with MonthlyLogins as(
    SELECT user_id,
    date_format(login_date,'%Y-%m') as month,
    count(*) as login_count
    from Logins 
    group by user_id,month 
),
RankedMonth as (
    SELECT user_id,
    month,
    login_count
    ROW_NUMBER() over(PARTITION by user_id order by login_count desc ) as rn 
    from MonthlyLogins 

)
SELECT user_id,
month,
login_count
from RankedMonth 
where rn=1 
order by month;