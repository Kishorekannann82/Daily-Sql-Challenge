/*
Calculate profit or loss per stock trade
You work at a trading platform like Zerodha. Each user buys and sells stocks. A buy followed by a sell of the same stock by the same user forms a trade. Match each sell to the most recent buy before it (FIFO — first in first out). Return user_id, stock, buy_price, sell_price, qty, and pnl (profit or loss = (sell - buy) * qty).
Table: trades
trade_id	user_id	stock	type	price	qty	trade_date
1	U01	INFY	buy	1500	10	2024-01-05
2	U01	INFY	sell	1750	10	2024-01-20
3	U01	TCS	buy	3500	5	2024-02-01
4	U01	TCS	sell	3200	5	2024-02-15
5	U02	INFY	buy	1600	8	2024-01-10
6	U02	INFY	sell	1900	8	2024-02-10
7	U02	WIPRO	buy	450	20	2024-01-15
8	U02	WIPRO	sell	420	20	2024-02-20
Expected output
user_id	stock	buy_price	sell_price	qty	pnl
U01	INFY	1500	1750	10	2500
U01	TCS	3500	3200	5	-1500
U02	INFY	1600	1900	8	2400
U02	WIPRO	450	420	20	-600
U01 INFY → buy 1500, sell 1750, qty 10 → PnL = (1750-1500)*10 = +2500 ✅ profit
U01 TCS → buy 3500, sell 3200, qty 5 → PnL = (3200-3500)*5 = -1500 ❌ loss
U02 INFY → buy 1600, sell 1900, qty 8 → PnL = (1900-1600)*8 = +2400 ✅ profit
U02 WIPRO → buy 450, sell 420, qty 20 → PnL = (420-450)*20 = -600 ❌ loss
*/
WITH buys AS (
  SELECT
    user_id, stock, price AS buy_price, qty,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, stock
      ORDER BY trade_date
    ) AS rn
  FROM trades
  WHERE type = 'buy'
),
sells AS (
  SELECT
    user_id, stock, price AS sell_price, qty,
    ROW_NUMBER() OVER (
      PARTITION BY user_id, stock
      ORDER BY trade_date
    ) AS rn
  FROM trades
  WHERE type = 'sell'
)
SELECT
  b.user_id,
  b.stock,
  b.buy_price,
  s.sell_price,
  b.qty,
  (s.sell_price - b.buy_price) * b.qty AS pnl
FROM buys b
JOIN sells s
  ON  b.user_id = s.user_id
  AND b.stock   = s.stock
  AND b.rn      = s.rn
ORDER BY b.user_id, b.stock;
