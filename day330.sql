/*
Find the click-through rate (CTR) per ad campaign
You work at a digital marketing company like Google Ads or Meta. The marketing team wants to calculate the Click-Through Rate (CTR) for each campaign. CTR = (total clicks / total impressions) * 100, rounded to 2 decimal places. Only return campaigns with at least 100 impressions. Return campaign_name, total_impressions, total_clicks, and ctr.
Table: campaigns
campaign_id	campaign_name
C01	Summer Sale
C02	New Year Blast
C03	Diwali Offer
C04	Flash Deal
Table: ad_events
event_id	campaign_id	event_type	event_date
1	C01	impression	2024-06-01
2	C01	impression	2024-06-01
3	C01	click	2024-06-01
4	C01	impression	2024-06-02
5	C01	click	2024-06-02
6	C02	impression	2024-06-01
7	C02	click	2024-06-01
8	C02	impression	2024-06-02
9	C03	impression	2024-06-01
10	C03	impression	2024-06-02
11	C03	impression	2024-06-03
12	C03	click	2024-06-03
13	C04	impression	2024-06-01
14	C04	click	2024-06-01
⚠️ Note: In this dataset each row = 1 event. But in real ad systems, there would be millions of rows — same query pattern applies.
Expected output
campaign_name	total_impressions	total_clicks	ctr
Summer Sale	3	2	66.67
New Year Blast	2	1	50.00
Diwali Offer	3	1	33.33
C01 Summer Sale → 3 impressions, 2 clicks → CTR = 2/3*100 = 66.67% ✅
C02 New Year Blast → 2 impressions, 1 click → CTR = 50.00% ✅
C03 Diwali Offer → 3 impressions, 1 click → CTR = 33.33% ✅
C04 Flash Deal → only 1 impression → below 100 threshold ❌ excluded
⚠️ The 100-impression threshold is real-world logic — in this toy dataset all counts are small, but the HAVING clause is what matters.
*/
select c.campagin_name,
sum(case when e.event_type="impression" then 1 else 0) end as impression,
sum(case when e.event_type=="click" then 1 else 0) end as click
round((clicks/impression)*100,2) as ctr
from campaigns c
join ad_events e 
on c.campaign_id=e.campaign_id
group by c.campagin_name
HAVING SUM(CASE WHEN ae.event_type = 'impression' THEN 1 ELSE 0 END) >= 100
ORDER BY ctr DESC;

--Powered by Kishore.
