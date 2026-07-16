/*
Find the winner and clearing price of each ad auction
You work at an ad exchange like Google Ad Manager. Each ad slot runs an auction where advertisers submit bids. The winner is the highest bidder but they pay the second highest bid (Vickrey/second-price auction). Return slot_id, winning_advertiser, winning_bid, clearing_price (second highest bid), and savings (winning_bid - clearing_price).
Table: auction_bids
bid_id	slot_id	advertiser	bid_amount
1	S01	Nike	500
2	S01	Adidas	420
3	S01	Puma	380
4	S02	Samsung	900
5	S02	Apple	850
6	S02	OnePlus	700
7	S03	Swiggy	300
8	S03	Zomato	300
9	S03	Blinkit	250
Expected output
slot_id	winning_advertiser	winning_bid	clearing_price	savings
S01	Nike	500	420	80
S02	Samsung	900	850	50
S03	Swiggy	300	300	0
S01 → Nike wins (500), pays Adidas's bid (420) → saves 80 ✅
S02 → Samsung wins (900), pays Apple's bid (850) → saves 50 ✅
S03 → Swiggy & Zomato tie at 300! Swiggy wins (first by bid_id), pays 300 (tied = same price) → saves 0
*/
WITH ranked AS (
  SELECT
    slot_id,
    advertiser,
    bid_amount,
    ROW_NUMBER() OVER (
      PARTITION BY slot_id
      ORDER BY bid_amount DESC, bid_id ASC
    ) AS rn,
    LEAD(bid_amount) OVER (
      PARTITION BY slot_id
      ORDER BY bid_amount DESC, bid_id ASC
    ) AS next_bid
  FROM auction_bids
)
SELECT
  slot_id,
  advertiser        AS winning_advertiser,
  bid_amount        AS winning_bid,
  next_bid          AS clearing_price,
  bid_amount - next_bid AS savings
FROM ranked
WHERE rn = 1
ORDER BY slot_id;
