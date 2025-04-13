--💡 Advanced SQL Challenge: Detect Suspicious Logins
--Scenario
--You are analyzing a table of user logins to detect suspicious behavior.
--Table :
Logins (
    user_id INT,
    login_time TIMESTAMP,
    ip_address VARCHAR(50)
)
/*Task:
Write a query to identify users who logged in from more than 3 different IP addresses within any 1-hour window.
Return:
user_id
window_start_time (the beginning of the 1-hour window)
distinct_ip_count
Constraints:
You may assume login_time is indexed.
Performance matters — do not use brute force or Cartesian joins.*/

--Query
with login_window as(
    select a.user_id,
    a.login_time as window_start_time,
    count(distinct ip_address) as distinct_ip_count
    from Logins a
    join Logins b 
    on a.user_id=b.user_id
    and b.login_time between a.login_time and a.login_time +INTERVAL '1 hour'
    group by a.user_id,a.login_time
)
select user_id,
    window_start,
    distinct_ip_count
FROM login_windows
WHERE distinct_ip_count > 3
ORDER BY user_id, window_start;
