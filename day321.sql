/*
Find drivers who earn above their city's median
You work at a ride-hailing company like Ola. The ops team wants to identify top performing drivers — specifically, drivers whose total monthly earnings exceed the median earnings of all drivers in their city for that same month. Return driver_id, city, month, their total_earnings, and the city_median.
Table: rides
ride_id	driver_id	city	ride_date	fare
1	D01	Chennai	2024-01-05	250
2	D01	Chennai	2024-01-12	400
3	D02	Chennai	2024-01-08	180
4	D02	Chennai	2024-01-20	220
5	D03	Chennai	2024-01-15	900
6	D04	Mumbai	2024-01-03	500
7	D04	Mumbai	2024-01-18	600
8	D05	Mumbai	2024-01-07	300
9	D05	Mumbai	2024-01-25	350
Expected output
driver_id	city	month	total_earnings	city_median
D03	Chennai	2024-01	900	650
D04	Mumbai	2024-01	1100	825
Chennai earnings → D01: 650, D02: 400, D03: 900 → median = 650. D03 (900) > 650 ✅
Mumbai earnings → D04: 1100, D05: 650 → median = 825. D04 (1100) > 825 ✅
D01 (650) = median, not strictly above → excluded ❌
D02 (400) < median → excluded ❌
D05 (650) < median → excluded ❌
*/
with monthly_earnings as(
    select driver_iud,city,date_trunc('month',ride_date) as month,sum(fare) as total_earnings
    from rides
    group by driver_id,city,date_trunc('month',ride_date)
),
with_median as(
    select driver_id,city,month,total_earnings,
    percentile_cont(0.5) within group (order by total_earnings) over(partition by city,month) as city_median
    from monthly_earnings
)
select driver_id,city,month,total_earnings,city_median
from with_median
where total_earnings > city_median
--End of the SQl Query;
--Powered by Kishore