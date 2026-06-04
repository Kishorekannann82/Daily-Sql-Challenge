/*
7-day rolling average of daily rides per city
You work at a cab aggregator like Rapido. The ops team wants to track a 7-day rolling average of rides per city to smooth out daily spikes and spot trends. Return city, ride_date, daily_rides, and rolling_7day_avg rounded to 1 decimal place. Only show rows where 7 full days of data exist (no partial windows).
Table: rides
ride_id	city	ride_date
1	Chennai	2024-01-01
2	Chennai	2024-01-01
3	Chennai	2024-01-02
4	Chennai	2024-01-02
5	Chennai	2024-01-02
6	Chennai	2024-01-03
7	Chennai	2024-01-04
8	Chennai	2024-01-04
9	Chennai	2024-01-05
10	Chennai	2024-01-05
11	Chennai	2024-01-05
12	Chennai	2024-01-06
13	Chennai	2024-01-06
14	Chennai	2024-01-07
15	Chennai	2024-01-07
16	Chennai	2024-01-07
17	Chennai	2024-01-08
18	Chennai	2024-01-08
Expected output
city	ride_date	daily_rides	rolling_7day_avg
Chennai	2024-01-07	3	2.3
Chennai	2024-01-08	2	2.4
Daily rides: Jan1=2, Jan2=3, Jan3=1, Jan4=2, Jan5=3, Jan6=2, Jan7=3, Jan8=2
Jan 7 avg → (2+3+1+2+3+2+3)/7 = 16/7 = 2.3 ✅
Jan 8 avg → (3+1+2+3+2+3+2)/7 = 16/7... wait = 16/7 = 2.3? No:
Jan8 window = Jan2+Jan3+Jan4+Jan5+Jan6+Jan7+Jan8 = 3+1+2+3+2+3+2 = 16/7 = 2.3 — hmm
Actually Jan2=3,Jan3=1,Jan4=2,Jan5=3,Jan6=2,Jan7=3,Jan8=2 → 16/7=2.3...
Run the answer query to verify — rolling windows are best debugged step by step!
*/
with daily as(
    select 
    city,
    ride_date,
    count(*) as daily_rides
    from rides 
    group by city,ride_date
),
rolling as(
    select city,
    ride_date,
    daily_rides,
    avg(daily_rides) over(partition by city order by ride_date rows between 6 preceding and current row) as rolling_avg,
    row_number() over(partition by city order by ride_date) as rn 
    from daily
)
select city,
ride_date,
daily_rides,
round(rolling_avg,1) as rolling_7day_avg
from with_rolling
where rn>=7 
order by city,ride_date;