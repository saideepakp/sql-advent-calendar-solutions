-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

with active as (
  select nu.user_name as usernm,nm.sender_id as ID,DATE(nm.sent_at) as Date, COUNT(nm.sender_id) as cnt
  from npn_users nu
  right join npn_messages nm
  on nu.user_id = nm.sender_id
  GROUP by nu.user_name, nm.sender_id,DATE(nm.sent_at)
  order by DATE(nm.sent_at)
),

active_users as(
  select ID, usernm, MAX(cnt) as maximum, Date, DENSE_RANK() OVER(partition by Date order by MAX(cnt) DESC) as rnk
  from active
  group by ID, usernm, Date
 order by Date
)

select ID, usernm, maximum, Date 
from active_users
where rnk = 1
