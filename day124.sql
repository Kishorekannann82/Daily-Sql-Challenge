/*
🧠 Challenge: First and Last Purchase Date per User
🗃️ Table: Purchases
*/
Purchases (
    purchase_id INT,
    user_id INT,
    product_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
)
/*
🎯 Your Task:
For each user, return:

First purchase date

Last purchase date

Total amount spent
*/
SELECT
min(purchase_date) as first_purchase_date,
max(purchase_date) as second_purchase_date,
sum(amount) as total_spent 
from Purchases
group by user_id;