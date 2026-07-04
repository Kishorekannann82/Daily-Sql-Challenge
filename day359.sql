/*
Find genres with the highest content completion rate
You work at a streaming platform like Netflix. Each content piece belongs to a genre. Users watch content and either complete it or drop off. Find the completion rate per genre — % of watch sessions where completed = 1. Return genre, total_watches, completions, and completion_rate rounded to 1 decimal. Order by completion rate descending.
Table: content
content_id	title	genre
C01	Breaking Bad	Drama
C02	Money Heist	Thriller
C03	Friends	Comedy
C04	Dark	Thriller
C05	The Office	Comedy
Table: watch_sessions
session_id	user_id	content_id	completed
1	U01	C01	1
2	U02	C01	1
3	U03	C01	0
4	U01	C02	1
5	U02	C02	1
6	U03	C02	1
7	U01	C03	1
8	U02	C03	0
9	U01	C04	0
10	U03	C04	1
11	U02	C05	1
12	U03	C05	1
Expected output
genre	total_watches	completions	completion_rate
Thriller	5	4	80.0
Comedy	4	3	75.0
Drama	3	2	66.7
Thriller → C02(3 watches, 3 complete) + C04(2 watches, 1 complete) = 5 watches, 4 complete → 80.0% 🏆
Comedy → C03(2 watches, 1 complete) + C05(2 watches, 2 complete) = 4 watches, 3 complete → 75.0%
Drama → C01(3 watches, 2 complete) = 3 watches, 2 complete → 66.7%
*/
SELECT
  c.genre,
  COUNT(*)                                  AS total_watches,
  SUM(ws.completed)                         AS completions,
  ROUND(
    SUM(ws.completed) * 100.0 / COUNT(*),
  1)                                         AS completion_rate
FROM content c
JOIN watch_sessions ws
  ON c.content_id = ws.content_id
GROUP BY c.genre
ORDER BY completion_rate DESC;
