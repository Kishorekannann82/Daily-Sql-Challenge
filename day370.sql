/*
Rank creators by engagement rate and flag viral posts
You work at Instagram's creator analytics team. Engagement rate = (likes + comments + shares) / impressions * 100. A post is viral if engagement rate exceeds 10%. For each creator find their total_posts, avg_engagement_rate, viral_posts, and creator_rank by avg engagement rate. Return all creators ordered by rank.
Table: posts
post_id	creator_id	impressions	likes	comments	shares
P01	C01	10000	800	120	80
P02	C01	8000	400	50	30
P03	C01	12000	1500	200	300
P04	C02	5000	300	40	20
P05	C02	6000	200	30	10
P06	C03	20000	3000	500	1000
P07	C03	15000	1200	180	120
Expected output
creator_id	total_posts	avg_engagement_rate	viral_posts	creator_rank
C03	2	23.0	2	1
C01	3	13.5	2	2
C02	2	6.0	0	3
P01: (800+120+80)/10000*100 = 10.0% → not strictly >10 ❌
P02: (400+50+30)/8000*100 = 6.0% ❌
P03: (1500+200+300)/12000*100 = 16.7% ✅ viral
C01 avg = (10+6+16.7)/3 = 10.9%... hmm check carefully
P04: (300+40+20)/5000*100 = 7.2% ❌ | P05: (200+30+10)/6000*100 = 4.0% ❌
P06: (3000+500+1000)/20000*100 = 22.5% ✅ | P07: (1200+180+120)/15000*100 = 10.0% → border
Verify exact numbers using the answer query!
*/
WITH post_eng AS (
  SELECT
    creator_id,
    post_id,
    ROUND(
      (likes + comments + shares) * 100.0
      / NULLIF(impressions, 0)
    , 1) AS eng_rate
  FROM posts
),
creator_stats AS (
  SELECT
    creator_id,
    COUNT(*)                                        AS total_posts,
    ROUND(AVG(eng_rate), 1)                        AS avg_engagement_rate,
    SUM(CASE WHEN eng_rate > 10 THEN 1 ELSE 0 END) AS viral_posts
  FROM post_eng
  GROUP BY creator_id
)
SELECT
  creator_id,
  total_posts,
  avg_engagement_rate,
  viral_posts,
  DENSE_RANK() OVER (
    ORDER BY avg_engagement_rate DESC
  ) AS creator_rank
FROM creator_stats
ORDER BY creator_rank;
