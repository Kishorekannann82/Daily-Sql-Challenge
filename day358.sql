/*
Find product pairs frequently bought together
You work at BigBasket. The recommendations team wants to find pairs of products that appear together in at least 2 orders — this powers the "Frequently Bought Together" feature. Return product_a, product_b, and times_bought_together. Each pair should appear only once (A, B) not (B, A).
Table: order_items
order_id	product
O01	Milk
O01	Bread
O01	Eggs
O02	Milk
O02	Bread
O02	Butter
O03	Eggs
O03	Bread
O03	Butter
O04	Milk
O04	Eggs
O05	Bread
O05	Butter
Expected output
product_a	product_b	times_bought_together
Bread	Butter	3
Bread	Milk	2
Bread	Eggs	2
Eggs	Milk	2
Bread+Butter → O02, O03, O05 = 3 times 🏆
Bread+Milk → O01, O02 = 2 times ✅
Bread+Eggs → O01, O03 = 2 times ✅
Eggs+Milk → O01, O04 = 2 times ✅
Milk+Butter → O02 only = 1 time ❌ excluded
Eggs+Butter → O03 only = 1 time ❌ excluded
*/
SELECT
  a.product          AS product_a,
  b.product          AS product_b,
  COUNT(*)           AS times_bought_together
FROM order_items a
JOIN order_items b
  ON  a.order_id = b.order_id
  AND a.product  < b.product
GROUP BY a.product, b.product
HAVING COUNT(*) >= 2
ORDER BY times_bought_together DESC, a.product;
