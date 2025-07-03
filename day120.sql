/*
🧠 Challenge: Users with At Least 3 Purchases in a Month
🗃️ Table: Purchases
*/
Purchases (
    purchase_id INT,
    user_id INT,
    purchase_date DATE,
    amount DECIMAL(10,2)
)
/*
🎯 Your Task:
Find all users who made at least 3 purchases in any month.
For each result, return:

user_id

month (formatted as 'YYYY-MM')

purchase_count (number of purchases in that month)

*/
select user_id,
date_format(purchase_date,'%Y-%m') as month,
count(*) as purchase_date
from Purchases
group by user_id,date_format(purchase_date,'%Y-%m') 
having count(*) >=3;