-- SQL Advent Calendar - Day 6
-- Title: Ski Resort Snowfall Rankings
-- Difficulty: hard
--
-- Question:
-- Buddy is planning a winter getaway and wants to rank ski resorts by annual snowfall. Can you help him bucket these ski resorts into quartiles?
--
-- Buddy is planning a winter getaway and wants to rank ski resorts by annual snowfall. Can you help him bucket these ski resorts into quartiles?
--

-- Table Schema:
-- Table: resort_monthly_snowfall
--   resort_id: INT
--   resort_name: VARCHAR
--   snow_month: INT
--   snowfall_inches: DECIMAL
--

-- My Solution:

with annual_snowfall as (
  select rank() over (order by sum(snowfall_inches)) as rank_no,
  resort_id, resort_name, sum(snowfall_inches) as total_snowfall
  from resort_monthly_snowfall
  group by resort_id, resort_name  
),

annual_snowfall_total as(
  select rank_no, resort_id, resort_name, total_snowfall,count(*) over() as total_rows
  from annual_snowfall
  )

select rank_no, resort_id, resort_name, total_snowfall,
  CASE
  when rank_no between 1 and total_rows/4 then 'Quartile 1'
  when rank_no between (total_rows/4)+1 and total_rows/2 then 'Quartile 2'
  when rank_no between (total_rows/2)+1 and 3*total_rows/4 then 'Quartile 3'
  else 'Quartile 4'
  end as Quartile
  from annual_snowfall_total
