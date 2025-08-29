/*
🧠 Challenge: Running Total of Sales Per User
🗃️ Table:
*/
Orders (
  order_id INT,
  user_id INT,
  order_date DATE,
  amount DECIMAL(10,2)
)
/*
🎯 Task:

For each user, show their orders in chronological order along with a running total of the amount they have spent so far.
*/
SELECT 
    user_id,
    order_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY user_id 
        ORDER BY order_date, order_id
    ) AS running_total
FROM Orders
ORDER BY user_id, order_date, order_id;
