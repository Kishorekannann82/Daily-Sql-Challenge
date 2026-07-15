/*
Detect round-trip money transfers (A→B→A)
You work at a bank's compliance team. A round-trip transfer is when Account A sends money to Account B, and then Account B sends money back to Account A — within 24 hours. This is a classic money laundering signal. Find all such pairs. Return account_a, account_b, a_to_b_amount, b_to_a_amount, a_to_b_time, b_to_a_time, and hours_gap.
Table: transfers
txn_id	from_acc	to_acc	amount	txn_time
T01	A001	A002	50000	2024-06-01 09:00
T02	A002	A001	48000	2024-06-01 14:00
T03	A001	A003	30000	2024-06-01 10:00
T04	A003	A001	30000	2024-06-02 11:00
T05	A004	A005	20000	2024-06-01 08:00
T06	A005	A004	19500	2024-06-01 20:00
T07	A006	A007	15000	2024-06-01 12:00
Expected output
account_a	account_b	a_to_b_amt	b_to_a_amt	a_to_b_time	b_to_a_time	hours_gap
A001	A002	50000	48000	09:00	14:00	5.0
A004	A005	20000	19500	08:00	20:00	12.0
A001→A002 (9am) then A002→A001 (2pm) → 5h gap ✅ within 24h → flagged!
A001→A003 (10am) then A003→A001 next day (11am) → 25h gap ❌ exceeds 24h
A004→A005 (8am) then A005→A004 (8pm) → 12h gap ✅ within 24h → flagged!
A006→A007 → no return transfer ❌
*/
SELECT
  t1.from_acc                                    AS account_a,
  t1.to_acc                                      AS account_b,
  t1.amount                                      AS a_to_b_amt,
  t2.amount                                      AS b_to_a_amt,
  t1.txn_time                                    AS a_to_b_time,
  t2.txn_time                                    AS b_to_a_time,
  ROUND(
    EXTRACT(EPOCH FROM (t2.txn_time - t1.txn_time))
    / 3600.0
  , 1)                                           AS hours_gap
FROM transfers t1
JOIN transfers t2
  ON  t1.from_acc = t2.to_acc
  AND t1.to_acc   = t2.from_acc
  AND t2.txn_time > t1.txn_time
WHERE
  EXTRACT(EPOCH FROM (t2.txn_time - t1.txn_time))
  / 3600.0 <= 24
  AND t1.from_acc < t1.to_acc
ORDER BY hours_gap;
