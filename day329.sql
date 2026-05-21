/*
Student pass/fail summary per course
You work at an EdTech platform like Unacademy. The academics team wants a report showing — for each course — how many students passed (score >= 50), how many failed (score < 50), and the pass rate % rounded to 1 decimal place. Return course_name, total_students, passed, failed, and pass_rate.
Table: results
result_id	student_id	course_name	score
1	S01	Data Science	72
2	S02	Data Science	45
3	S03	Data Science	88
4	S04	Data Science	39
5	S05	Data Science	91
6	S01	Web Dev	55
7	S02	Web Dev	48
8	S03	Web Dev	60
9	S04	Web Dev	77
10	S01	Cybersecurity	33
11	S02	Cybersecurity	41
12	S03	Cybersecurity	29
Expected output
course_name	total_students	passed	failed	pass_rate
Cybersecurity	3	0	3	0.0
Data Science	5	3	2	60.0
Web Dev	4	3	1	75.0
Data Science → scores: 72✅ 45❌ 88✅ 39❌ 91✅ → 3 pass, 2 fail, 60.0%
Web Dev → 55✅ 48❌ 60✅ 77✅ → 3 pass, 1 fail, 75.0%
Cybersecurity → 33❌ 41❌ 29❌ → 0 pass, 3 fail, 0.0%
*/
select course_name,count(*),
sum(Case when score>=50 then 1 else 0 end) as passed,
sum(case when score<50 then 1 else 0 end) as failed
ROUND(
    SUM(CASE WHEN score >= 50 THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
  1) 
from results 
group by course_name;

--Powered by Kishore.
