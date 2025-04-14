/*🚨 Advanced SQL Challenge: Detect Back-and-Forth Money Transfers
Scenario
You have a table of money transfers between users. You want to detect back-and-forth transfers, which could indicate suspicious behavior
 (e.g. money laundering).
 Find all pairs of users where:
User A sent money to User B AND
Within the next 10 minutes, User B sent money back to User A (any amount)
Return:
sender_id (User A)
receiver_id (User B)
sent_time (when A sent to B)
returned_time (when B sent back to A)
sender_id |	receiver_id|	transfer_time
101|	202	2024-04-13| 10:00:00
202|	101|	2024-04-13 |10:07:00
⚠️ Constraints:
Only consider transfers that returned within 10 minutes
Don't count loops where sender = receiver */
--Query
select a.sender_id,b.sender_id,
        a.receiver_id,b.receiver_id,
        a.transfer_time,b.transfer_time
from transfers A
join transfers B
on a.sender_id=b.sender_id and a.receiver_id=b.receiver_id 
AND a.receiver_id = b.sender_id
AND b.transfer_time BETWEEN a.transfer_time AND a.transfer_time + INTERVAL '10 minutes'
WHERE a.sender_id != a.receiver_id
ORDER BY a.sender_id, a.transfer_time;



