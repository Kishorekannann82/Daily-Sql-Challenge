/*
Calculate Net Promoter Score (NPS) per product
You work at a product analytics company. Users rate products on a scale of 1–10:

😍 Promoters — score 9 or 10
😐 Passives — score 7 or 8
😠 Detractors — score 1 to 6

NPS = % Promoters − % Detractors (can be negative). Return product_name, total_responses, promoters, passives, detractors, and nps rounded to 1 decimal. Order by NPS descending.
Table: nps_responses
response_id	product_name	score
1	App A	9
2	App A	10
3	App A	8
4	App A	6
5	App A	9
6	App B	7
7	App B	5
8	App B	3
9	App B	8
10	App C	10
11	App C	10
12	App C	9
13	App C	4
Expected output
product_name	total_responses	promoters	passives	detractors	nps
App C	4	3	0	1	50.0
App A	5	3	1	1	40.0
App B	4	0	2	2	-50.0
App A → promoters=3(9,10,9) passive=1(8) detractor=1(6) → NPS=(3-1)/5*100=40.0 ✅
App B → promoters=0 passive=2(7,8) detractor=2(5,3) → NPS=(0-2)/4*100=-50.0 ✅
App C → promoters=3(10,10,9) passive=0 detractor=1(4) → NPS=(3-1)/4*100=50.0 ✅
*/
SELECT
  product_name,
  COUNT(*)                                              AS total_responses,
  SUM(CASE WHEN score >= 9            THEN 1 ELSE 0 END) AS promoters,
  SUM(CASE WHEN score BETWEEN 7 AND 8 THEN 1 ELSE 0 END) AS passives,
  SUM(CASE WHEN score <= 6            THEN 1 ELSE 0 END) AS detractors,
  ROUND(
    (SUM(CASE WHEN score >= 9 THEN 1 ELSE 0 END)
   - SUM(CASE WHEN score <= 6 THEN 1 ELSE 0 END))
    * 100.0 / COUNT(*)
  , 1)                                                  AS nps
FROM nps_responses
GROUP BY product_name
ORDER BY nps DESC;
