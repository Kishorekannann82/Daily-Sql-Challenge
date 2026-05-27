/*
Find suppliers delivering more than 20% defective items
You work at a supply chain company like Flipkart's warehouse team. Each shipment from a supplier contains items that are either good or defective. Find all suppliers whose defective item rate exceeds 20% across all their shipments. Return supplier_name, total_items, defective_items, and defect_rate rounded to 1 decimal place.
Table: suppliers
supplier_id	supplier_name
S01	RapidParts Co
S02	MegaSupply Ltd
S03	QuickStock Inc
S04	PrimeSource
Table: shipment_items
item_id	supplier_id	shipment_date	quality
1	S01	2024-03-01	good
2	S01	2024-03-01	good
3	S01	2024-03-02	defective
4	S01	2024-03-02	good
5	S01	2024-03-03	good
6	S02	2024-03-01	good
7	S02	2024-03-01	defective
8	S02	2024-03-02	defective
9	S02	2024-03-03	defective
10	S03	2024-03-01	good
11	S03	2024-03-02	good
12	S03	2024-03-03	good
13	S03	2024-03-04	good
14	S04	2024-03-01	defective
15	S04	2024-03-02	good
16	S04	2024-03-03	defective
17	S04	2024-03-04	defective
18	S04	2024-03-05	good
Expected output
supplier_name	total_items	defective_items	defect_rate
MegaSupply Ltd	4	3	75.0
PrimeSource	5	3	60.0
S01 RapidParts → 5 items, 1 defective → 20.0% → not strictly > 20% ❌
S02 MegaSupply → 4 items, 3 defective → 75.0% ✅
S03 QuickStock → 4 items, 0 defective → 0.0% ❌
S04 PrimeSource → 5 items, 3 defective → 60.0% ✅
*/
select si.supplier_id,s.supplier_name,
count(*) as total_items,
sum(case when si.qualify="defective" then 1 else 0 end) as defective_items,
Round(
    sum(case when si.qualify="defective" then 1 else 0 end)*100.0/Count(*),1
) as defect_rate
from suppliers s 
join supplier_items si
on s.supplier_id=si.supplier_items
group by s.supllier_id,s.supplier_name
having 
    sum(case when si.quality="defective" then 1 else 0 end)/Count(*)>20
order by defect_rate desc;

--The End

