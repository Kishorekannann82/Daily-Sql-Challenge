/*
You work at a streaming platform like Netflix. The product team wants to segment users based on how many shows they watched this month into three tiers — Casual (1–2 shows), Regular (3–5 shows), and Binge Watcher (6+ shows). Return each user_id, their shows_watched, and their segment.
Table: watch_history
watch_id	user_id	show_name	watched_on
1	U01	Breaking Bad	2024-07-02
2	U01	Squid Game	2024-07-10
3	U02	Money Heist	2024-07-01
4	U02	Dark	2024-07-05
5	U02	Stranger Things	2024-07-09
6	U02	Ozark	2024-07-14
7	U03	The Crown	2024-07-03
8	U03	Mindhunter	2024-07-07
9	U03	Narcos	2024-07-11
10	U03	Peaky Blinders	2024-07-15
11	U03	The Witcher	2024-07-18
12	U03	Lupin	2024-07-22
13	U04	Friends	2024-07-06

Expected output
user_id	shows_watched	segment
U01	2	Casual
U02	4	Regular
U03	6	Binge Watcher
U04	1	Casual
*/

with user_counts as(
select user_id,
count(distinct show_name) as shows_watched
from watch_history 
where watched_on>='2024-07-01'
    AND watched_on <  '2024-08-01'
  GROUP BY user_id
)
select user_id,shows_watched,
case when shows_watched>=6 then "Binge Watcher"
case when shows_watched>=3 then "regular"
else "Casual"
end as segnment
from user_counts
order by shows_watched desc;