--DAY_2 SQL CHALLenge
--identify the customers who had made the purchases on exactly three dates in last month.
--Amazon Interview Question
--Query:
select customer_ID
FROM purchases
WHERE PURCHASE_DATE>=DATE_FORMAT(CURDATE()-INTERVAL 1 MONTH,'%Y-%M-01')
AND PURCHASE_DATE<=DATE_FORMAT(CURDATE()-'%Y-%M-01')
GROUP BY customer_ID
HAVING COUNT(DISTINCT DATE(PURCHASE_DATE))=3