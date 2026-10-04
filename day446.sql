/*
📌 Challenge 2.0 — Day 51: "Social Network — Mutual Friends Count"

Scenario:
You're a Data Analyst at a social networking app. The "People You May Know" feature needs a mutual friends count between any two users who aren't already friends — the more mutual friends, the higher the suggestion ranks.

Table: friendships

Column	Type
user_id_1	INT
user_id_2	INT

(Assume friendships are stored one row per pair, with user_id_1 < user_id_2 always — i.e., already normalized, undirected.)

Task: For every pair of users who are not currently friends, calculate how many mutual friends they share. Output user_a, user_b, mutual_friends_count — only pairs with at least 1 mutual friend, top 20 by count.
*/
WITH all_friends AS (
    -- Flatten the normalized pairs into a bidirectional adjacency list
    SELECT user_id_1 AS user_id, user_id_2 AS friend_id FROM friendships
    UNION ALL
    SELECT user_id_2 AS user_id, user_id_1 AS friend_id FROM friendships
),
candidate_pairs AS (
    -- Any two users who share at least one common friend
    SELECT 
        f1.user_id AS user_a,
        f2.user_id AS user_b,
        COUNT(DISTINCT f1.friend_id) AS mutual_friends_count
    FROM all_friends f1
    JOIN all_friends f2 
        ON f1.friend_id = f2.friend_id      -- same mutual friend
        AND f1.user_id < f2.user_id          -- avoid duplicate pairs + self-pairing
    GROUP BY f1.user_id, f2.user_id
)
SELECT 
    cp.user_a,
    cp.user_b,
    cp.mutual_friends_count
FROM candidate_pairs cp
LEFT JOIN friendships fr 
    ON fr.user_id_1 = cp.user_a AND fr.user_id_2 = cp.user_b
WHERE fr.user_id_1 IS NULL   -- exclude pairs who are already friends
ORDER BY cp.mutual_friends_count DESC
LIMIT 20;
