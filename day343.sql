/*
Detect products with a sudden price spike (>20%)
You work at an e-commerce marketplace like Amazon or Meesho. The pricing team wants to detect products whose price increased by more than 20% compared to their previous listed price — these could be seller manipulation or sudden demand spikes. Return product_name, prev_price, new_price, pct_increase, and changed_on.
Table: price_history
price_id	product_name	price	listed_on
1	USB-C Cable	199	2024-01-01
2	USB-C Cable	199	2024-01-10
3	USB-C Cable	299	2024-01-20
4	Wireless Earbuds	1499	2024-01-01
5	Wireless Earbuds	1599	2024-01-15
6	Wireless Earbuds	2199	2024-02-01
7	Phone Case	299	2024-01-05
8	Phone Case	319	2024-01-25
9	Laptop Stand	899	2024-01-01
10	Laptop Stand	1099	2024-02-01
Expected output
product_name	prev_price	new_price	pct_increase	changed_on
USB-C Cable	199	299	50.3	2024-01-20
Wireless Earbuds	1599	2199	37.5	2024-02-01
Laptop Stand	899	1099	22.2	2024-02-01
USB-C Cable → 199→199 (0% no spike) → 199→299 (50.3% ❗ spike!) ✅
Wireless Earbuds → 1499→1599 (6.7% fine) → 1599→2199 (37.5% ❗ spike!) ✅
Phone Case → 299→319 (6.7% fine) → no spike ❌
Laptop Stand → 899→1099 (22.2% ❗ just over 20%) ✅
Answer
*/
WITH price_with_prev AS (
  SELECT
    product_name,
    price                                        AS new_price,
    listed_on                                    AS changed_on,
    LAG(price) OVER (
      PARTITION BY product_name
      ORDER BY listed_on
    )                                            AS prev_price
  FROM price_history
)
SELECT
  product_name,
  prev_price,
  new_price,
  ROUND(
    (new_price - prev_price) * 100.0
    / NULLIF(prev_price, 0)
  , 1)                                           AS pct_increase,
  changed_on
FROM price_with_prev
WHERE
  prev_price IS NOT NULL
  AND (new_price - prev_price) * 100.0
      / NULLIF(prev_price, 0) > 20
ORDER BY pct_increase DESC;
