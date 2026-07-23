/*
Calculate maximum drawdown for each stock
You work at Zerodha's risk analytics team. Maximum Drawdown (MDD) is the largest peak-to-trough decline in a stock's price — a key risk metric. For each stock, find the peak price seen so far at each date using a running maximum, then compute the drawdown = (current_price - running_peak) / running_peak * 100. Return the maximum drawdown (most negative value) per stock with its date.
Table: stock_prices
price_id	stock	price_date	close_price
1	INFY	2024-01-01	1500
2	INFY	2024-01-02	1600
3	INFY	2024-01-03	1400
4	INFY	2024-01-04	1300
5	INFY	2024-01-05	1550
6	TCS	2024-01-01	3500
7	TCS	2024-01-02	3800
8	TCS	2024-01-03	3600
9	TCS	2024-01-04	3200
10	TCS	2024-01-05	3400
Expected output
stock	max_drawdown_date	peak_price	trough_price	max_drawdown_pct
INFY	2024-01-04	1600	1300	-18.8
TCS	2024-01-04	3800	3200	-15.8
INFY peak = 1600 (Jan2). Jan4 close = 1300 → drawdown = (1300-1600)/1600*100 = -18.75% → worst day
TCS peak = 3800 (Jan2). Jan4 close = 3200 → drawdown = (3200-3800)/3800*100 = -15.79% → worst day
Both stocks hit their worst drawdown on Jan 4 ✅
*/
WITH running_peak AS (
  SELECT
    stock,
    price_date,
    close_price,
    MAX(close_price) OVER (
      PARTITION BY stock
      ORDER BY price_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS peak_so_far
  FROM stock_prices
),
drawdowns AS (
  SELECT
    stock,
    price_date,
    close_price,
    peak_so_far,
    ROUND(
      (close_price - peak_so_far) * 100.0 / peak_so_far
    , 1) AS drawdown_pct
  FROM running_peak
),
worst_drawdown AS (
  SELECT
    stock,
    price_date,
    peak_so_far      AS peak_price,
    close_price      AS trough_price,
    drawdown_pct     AS max_drawdown_pct,
    ROW_NUMBER() OVER (
      PARTITION BY stock
      ORDER BY drawdown_pct ASC
    ) AS rn
  FROM drawdowns
)
SELECT
  stock,
  price_date    AS max_drawdown_date,
  peak_price,
  trough_price,
  max_drawdown_pct
FROM worst_drawdown
WHERE rn = 1
ORDER BY max_drawdown_pct;
