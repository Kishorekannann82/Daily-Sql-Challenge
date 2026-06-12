ABC inventory classification by revenue contribution
You work at a retail chain like DMart. The inventory team uses ABC analysis to classify products:

🅐 A items — top products contributing to the first 70% of total revenue
🅑 B items — next products contributing from 70% to 90%
🅒 C items — remaining products contributing the last 10%

Return product_name, revenue, cumulative_pct, and abc_class.
Table: product_sales
product_id	product_name	revenue
P01	Rice 5kg	85000
P02	Cooking Oil	62000
P03	Sugar 1kg	41000
P04	Wheat Flour	28000
P05	Salt	14000
P06	Tea Powder	9000
P07	Biscuits	5000
P08	Soap	3000
P09	Shampoo	2000
P10	Toothpaste	1000
Expected output
product_name	revenue	cumulative_pct	abc_class
Rice 5kg	85000	34.0	A
Cooking Oil	62000	58.8	A
Sugar 1kg	41000	75.2	B
Wheat Flour	28000	86.4	B
Salt	14000	92.0	C
Tea Powder	9000	95.6	C
Biscuits	5000	97.6	C
Soap	3000	98.8	C
Shampoo	2000	99.6	C
Toothpaste	1000	100.0	C
Total revenue = 250,000
Rice 5kg → 85000/250000 = 34.0% cumulative → A ✅
Cooking Oil → 34.0 + 24.8 = 58.8% → still under 70% → A ✅
Sugar 1kg → 58.8 + 16.4 = 75.2% → crossed 70% → B ✅
Wheat Flour → 75.2 + 11.2 = 86.4% → still under 90% → B ✅
Salt onwards → crossed 90% → C ✅
Hint
Next problem ↗
Answer
WITH running AS (
  SELECT
    product_name,
    revenue,
    ROUND(
      SUM(revenue) OVER (
        ORDER BY revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) * 100.0
      / SUM(revenue) OVER ()
    , 1) AS cumulative_pct
  FROM product_sales
)
SELECT
  product_name,
  revenue,
  cumulative_pct,
  CASE
    WHEN cumulative_pct <= 70 THEN 'A'
    WHEN cumulative_pct <= 90 THEN 'B'
    ELSE                           'C'
  END AS abc_class
FROM running
ORDER BY revenue DESC;
