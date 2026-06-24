/*
Find the winner and vote share in each constituency
You work at an election data analytics firm. For each constituency, find the winning candidate (most votes), their total votes, the total votes polled in that constituency, and their vote share % rounded to 1 decimal. If there's a tie for first, return all tied winners.
Table: votes
vote_id	constituency	candidate	votes
1	Salem North	Rajan	4500
2	Salem North	Suresh	3200
3	Salem North	Priya	1800
4	Chennai Central	Arjun	8100
5	Chennai Central	Bala	8100
6	Chennai Central	Charu	2400
7	Coimbatore	Mani	6700
8	Coimbatore	Selvi	5300
9	Coimbatore	Raj	2100
Expected output
constituency	winner	winner_votes	total_votes	vote_share
Chennai Central	Arjun	8100	18600	43.5
Chennai Central	Bala	8100	18600	43.5
Coimbatore	Mani	6700	14100	47.5
Salem North	Rajan	4500	9500	47.4
Salem North → Rajan 4500 wins, total 9500, share = 4500/9500*100 = 47.4% ✅
Chennai Central → Arjun & Bala both 8100 — tie! Both returned ✅
Coimbatore → Mani 6700 wins, total 14100, share = 47.5% ✅
*/
WITH ranked AS (
  SELECT
    constituency,
    candidate,
    votes,
    SUM(votes) OVER (
      PARTITION BY constituency
    )                          AS total_votes,
    DENSE_RANK() OVER (
      PARTITION BY constituency
      ORDER BY votes DESC
    )                          AS rnk
  FROM votes
)
SELECT
  constituency,
  candidate        AS winner,
  votes            AS winner_votes,
  total_votes,
  ROUND(votes * 100.0 / total_votes, 1) AS vote_share
FROM ranked
WHERE rnk = 1
ORDER BY constituency, winner;
