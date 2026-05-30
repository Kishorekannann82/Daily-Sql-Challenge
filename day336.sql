/*
Top 3 players by score in each game
You work at a mobile gaming platform like MPL or WinZO. The product team wants a leaderboard showing the top 3 players by total score in each game. If there's a tie at position 3, include all tied players. Return game_name, player_name, total_score, and rank.
Table: game_scores
score_id	player_name	game_name	score
1	Rohit	Battle Royale	450
2	Sneha	Battle Royale	380
3	Karan	Battle Royale	500
4	Divya	Battle Royale	380
5	Arjun	Battle Royale	290
6	Priya	Battle Royale	410
7	Rohit	Puzzle Rush	700
8	Sneha	Puzzle Rush	850
9	Karan	Puzzle Rush	620
10	Divya	Puzzle Rush	910
11	Arjun	Puzzle Rush	780
Expected output
game_name	player_name	total_score	rank
Battle Royale	Karan	500	1
Battle Royale	Priya	410	2
Battle Royale	Rohit	450	3
Battle Royale	Sneha	380	3
Battle Royale	Divya	380	3
Puzzle Rush	Divya	910	1
Puzzle Rush	Sneha	850	2
Puzzle Rush	Arjun	780	3
Battle Royale → Karan(500)🥇 Priya(410)🥈 Rohit(450)... wait — Rohit is rank 3?
Sorted: Karan 500 → rank 1, Priya 410 → rank 2, Rohit 450 → rank 3...
Wait: 500, 450, 410, 380, 380 → Karan(500)🥇 Rohit(450)🥈 Priya(410)🥉 Sneha(380) rank 4... hmm
Careful: Sneha(380) and Divya(380) both tie at rank 4 → excluded. Top 3 = Karan, Rohit, Priya — but with DENSE_RANK ties at 3 get included. Check the answer for the correct rank ordering!
*/
with total_score as(
    select game_name,player_name,
    sum(score) as total_score
    from game_scores
    group by game_name,player_name
),
ranked as(
    select game_name,
    player_name,
    total_score,
    dense_rank() over(partition by game_name order by total_score desc) as rnk
    from player_totals
)
select game_name,
player_name,
total_score,
rnk as rank
from ranked
where rnk<=3 
order by game_name,rnk,total_score desc;
