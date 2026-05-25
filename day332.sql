/*
Find mutual followers (users who follow each other)
You work at a social media company like Instagram. The growth team wants to find all pairs of users who mutually follow each other — i.e., A follows B AND B follows A. Return each pair only once (not both A→B and B→A). Return user_1, user_2.
Table: follows
follower_id	followee_id
U01	U02
U02	U01
U01	U03
U03	U01
U02	U03
U04	U01
U03	U05
U05	U03
Expected output
user_1	user_2
U01	U02
U01	U03
U03	U05
U01↔U02 → both follow each other ✅ shown as (U01, U02)
U01↔U03 → both follow each other ✅ shown as (U01, U03)
U02→U03 → U03 doesn't follow U02 back ❌ not mutual
U04→U01 → U01 doesn't follow U04 back ❌ not mutual
U03↔U05 → both follow each other ✅ shown as (U03, U05)
*/
SELECT
  a.follower_id AS user_1,
  a.followee_id AS user_2
FROM follows a
JOIN follows b
  ON  a.follower_id = b.followee_id
  AND a.followee_id = b.follower_id
WHERE a.follower_id < a.followee_id
ORDER BY user_1, user_2;
