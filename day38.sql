/* Prime subscription rate by product action
give the following table,return the fraction of users,rounded to two decimal places
who accesed amazon music and upgraded to prime subscription membership within the first 30 days of signining up. */
--Query


select u.*,e.type,
e.access_date,
datediff(day,u.join_date,e.access_date) as no_of_days 
from users u
left join events e
 on u.user_id=e.user_id and e.type='P'
where user_id in (select user_id from events where type="Music")