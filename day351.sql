/*
Find students who enrolled but never completed any course
You work at an EdTech platform like Coursera. The content team wants to find students who enrolled in at least 2 courses but never completed even one. These are dropout-risk users to target with re-engagement campaigns. Return student_name and enrolled_courses.
Table: students
student_id	student_name
S01	Aakash
S02	Bharti
S03	Chandra
S04	Deepak
S05	Eswari
Table: enrollments
enroll_id	student_id	course_name	status
1	S01	Python Basics	completed
2	S01	Data Science	enrolled
3	S02	Python Basics	enrolled
4	S02	Web Dev	enrolled
5	S02	SQL Mastery	enrolled
6	S03	Data Science	enrolled
7	S03	Machine Learning	completed
8	S04	Web Dev	enrolled
9	S04	SQL Mastery	enrolled
10	S05	Python Basics	enrolled
Expected output
student_name	enrolled_courses
Bharti	3
Deepak	2
S01 Aakash → completed Python Basics → has 1 completion ❌ excluded
S02 Bharti → 3 courses, 0 completions ✅ dropout risk
S03 Chandra → completed ML → has completion ❌ excluded
S04 Deepak → 2 courses, 0 completions ✅ dropout risk
S05 Eswari → only 1 course enrolled → fails "at least 2" rule ❌
*/
SELECT
  s.student_name,
  COUNT(e.enroll_id) AS enrolled_courses
FROM students s
JOIN enrollments e
  ON s.student_id = e.student_id
WHERE NOT EXISTS (
  SELECT 1
  FROM enrollments e2
  WHERE e2.student_id = s.student_id
    AND e2.status = 'completed'
)
GROUP BY s.student_id, s.student_name
HAVING COUNT(e.enroll_id) >= 2
ORDER BY enrolled_courses DESC;
