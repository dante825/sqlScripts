

create table dibots_v2.exchange_demography_stock_rank (
trading_date date,
week_count varchar(10),
month int,
year int,
qtr int,
stock_code varchar(20),
stock_name varchar(255),
board varchar(255),
sector varchar(255),
value_day numeric(25,3),
rank_overall_day int,
rank_board_day int,
rank_sector_day int,
rank_board_sector_day int,
value_week numeric(25,3),
rank_overall_week int,
rank_board_week int,
rank_sector_week int,
rank_board_sector_week int,
value_month numeric(25,3),
rank_overall_month int,
rank_board_month int,
rank_sector_month int,
rank_board_sector_month int,
value_qtr numeric(25,3),
rank_overall_qtr int,
rank_board_qtr int,
rank_sector_qtr int,
rank_board_sector_qtr int,
value_year numeric(25,3),
rank_overall_year int,
rank_board_year int,
rank_sector_year int,
rank_board_sector_year int
) PARTITION BY RANGE(trading_date);

alter table dibots_v2.exchange_demography_stock_rank add constraint ed_stock_rank_pkey PRIMARY KEY (trading_date, stock_code);
create index ed_stock_rank_stck_idx on dibots_v2.exchange_demography_stock_rank (stock_code);
create index ed_stock_rank_board_idx on dibots_v2.exchange_demography_stock_rank (board);
create index ed_stock_rank_sector_idx on dibots_v2.exchange_demography_stock_rank (sector);

create table dibots_v2.exchange_demography_stock_rank_y2017_2019 partition of dibots_v2.exchange_demography_stock_rank
for values from ('2017-01-01') to ('2020-01-01');
create table dibots_v2.exchange_demography_stock_rank_y2020_2022 partition of dibots_v2.exchange_demography_stock_rank
for values from ('2020-01-01') to ('2023-01-01');
create table dibots_v2.exchange_demography_stock_rank_y2023_2025 partition of dibots_v2.exchange_demography_stock_rank
for values from ('2023-01-01') to ('2025-01-01');
create table dibots_v2.exchange_demography_stock_rank_default partition of dibots_v2.exchange_demography_stock_rank default;


--==================================================
-- exchange_demography_stock_rank INSERTION SCRIPT
--==================================================

-- A PARTITIONED TABLE, CREATION SCRIPT REFER TO exchange_demography_partitioned_tables.sql

insert into dibots_v2.exchange_demography_stock_rank (trading_date, week_count, month, year, stock_code, stock_name, board, sector, value_day)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(month from trading_date), extract(year from trading_date), stock_code, stock_name, board, sector, sum(value)
from dibots_v2.exchange_demography_stock_movement
group by trading_date, stock_code, stock_name, board, sector;

select * from dibots_v2.exchange_demography_stock_rank order by trading_date desc

update dibots_v2.exchange_demography_stock_rank
set
qtr = case when month in (1,2,3) then 1
		when month in (4,5,6) then 2
		when month in (7,8,9) then 3
		when month in (10,11,12) then 4
		end;

-- day rank
update dibots_v2.exchange_demography_stock_rank a
set
rank_overall_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_board_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, board order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_sector_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, sector order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_board_sector_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, board, sector order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

-- Historical data is populated with a PYTHON script, refer to: project BrokerRankToDate -> stockRank directory


--===============================
-- INCREMENTAL UPDATE
--==============================
-- need to run day by day, cannot update all in one go
insert into dibots_v2.exchange_demography_stock_rank (trading_date, week_count, month, year, stock_code, stock_name, board, sector, value_day)
select trading_date, to_char(trading_date, 'IYYY-IW'), extract(month from trading_date), extract(year from trading_date), stock_code, stock_name, board, sector, sum(value)
from dibots_v2.exchange_demography_stock_movement where trading_date > (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, stock_name, board, sector;

update dibots_v2.exchange_demography_stock_rank a
set
qtr = case when month in (1,2,3) then 1
		when month in (4,5,6) then 2
		when month in (7,8,9) then 3
		when month in (10,11,12) then 4
		end
where a.qtr is null;


select sum(value_day) from dibots_v2.exchange_demography_stock_rank where week_count = '2021-03' and stock_code = '7113'

update dibots_v2.exchange_demography_stock_rank a
set
value_week = tmp.val
from (
select week_count, stock_code, sum(value_day) as val
from dibots_v2.exchange_demography_stock_rank
where week_count = (select week_count from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1)
and trading_date <= (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by week_count, stock_code) tmp
where a.stock_code = tmp.stock_code and a.trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank);

update dibots_v2.exchange_demography_stock_rank a
set
value_month = tmp.val
from (
select year, month, stock_code, sum(value_day) as val
from dibots_v2.exchange_demography_stock_rank
where year = (select year from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1) 
and month = (select month from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1)
and trading_date <= (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by year, month, stock_code) tmp
where a.stock_code = tmp.stock_code and a.trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank);

update dibots_v2.exchange_demography_stock_rank a
set
value_qtr = tmp.val
from (
select year, qtr, stock_code, sum(value_day) as val
from dibots_v2.exchange_demography_stock_rank
where year = (select year from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1) 
and qtr = (select qtr from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1)
and trading_date <= (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by year, qtr, stock_code) tmp
where a.stock_code = tmp.stock_code and a.trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank);

update dibots_v2.exchange_demography_stock_rank a
set
value_year = tmp.val
from (
select year, stock_code, sum(value_day) as val
from dibots_v2.exchange_demography_stock_rank
where year = (select year from dibots_v2.exchange_demography_stock_rank where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank) limit 1) 
and trading_date <= (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by year, stock_code) tmp
where a.stock_code = tmp.stock_code and a.trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank);


-- ranking

update dibots_v2.exchange_demography_stock_rank a
set
rank_overall_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_board_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, board order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_sector_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, sector order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;

update dibots_v2.exchange_demography_stock_rank a
set
rank_board_sector_day = tmp.rank
from
(select trading_date, stock_code, rank() over (partition by trading_date, board, sector order by value_day desc) rank
from dibots_v2.exchange_demography_stock_rank
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code;


update dibots_v2.exchange_demography_stock_rank a
set rank_overall_week = tmp.rank 
from (select trading_date, stock_code, rank() over (partition by trading_date order by sum(value_week) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code ) tmp
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_overall_week is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_week = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board order by sum(value_week) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_week is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_sector_week = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, sector order by sum(value_week) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, sector) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_sector_week is null;

update dibots_v2.exchange_demography_stock_rank a
set rank_board_sector_week = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board, sector order by sum(value_week) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board, sector ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_sector_week is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_overall_month = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date order by sum(value_month) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_overall_month is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_month = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board order by sum(value_month) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_month is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_sector_month = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, sector order by sum(value_month) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, sector) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_sector_month is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_sector_month = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board, sector order by sum(value_month) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board, sector ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_sector_month is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_overall_qtr = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date order by sum(value_qtr) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_overall_qtr is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_qtr = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board order by sum(value_qtr) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_qtr is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_sector_qtr = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, sector order by sum(value_qtr) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, sector) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_sector_qtr is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_sector_qtr = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board, sector order by sum(value_qtr) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board, sector ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_sector_qtr is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_overall_year = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date order by sum(value_year) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_overall_year is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_year = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board order by sum(value_year) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_year is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_sector_year = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, sector order by sum(value_year) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, sector) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_sector_year is null;

update dibots_v2.exchange_demography_stock_rank a 
set rank_board_sector_year = tmp.rank 
from (select trading_date, stock_code, 
rank() over (partition by trading_date, board, sector order by sum(value_year) desc) rank 
from dibots_v2.exchange_demography_stock_rank 
where trading_date = (select max(trading_date) from dibots_v2.exchange_demography_stock_rank)
group by trading_date, stock_code, board, sector ) tmp 
where a.trading_date = tmp.trading_date and a.stock_code = tmp.stock_code and rank_board_sector_year is null;

-- verification
select * from dibots_v2.exchange_demography_stock_rank where trading_date = '2021-01-25' and sector = 'HEALTH CARE' and board = 'MAIN MARKET'

select * from dibots_v2.exchange_demography_stock_rank where rank_board_sector_week is not null

select stock_code, stock_name, sum(value) from dibots_v2.exchange_demography_stock_rank 
where trading_date between '2021-01-20'::date - interval '1 week' and '2021-01-20'::date
and sector = 'HEALTH CARE' and board = 'MAIN MARKET'
group by stock_code, stock_name
order by sum(value) desc

select stock_code, stock_name, sum(value_day) from dibots_v2.exchange_demography_stock_rank
where week_count = '2021-03' and board = 'MAIN MARKET' and sector = 'HEALTH CARE' and trading_date <= '2021-01-19'
group by stock_code, stock_name
order by sum(value_day) desc

select stock_code, stock_name, value_day from dibots_v2.exchange_demography_stock_rank
where trading_date = '2021-01-19' and board = 'MAIN MARKET' and sector = 'HEALTH CARE'
order by value_day desc

select distinct trading_date from dibots_v2.exchange_demography_stock_rank order by trading_date asc

select week_count from dibots_v2.exchange_demography_stock_rank where trading_date = '2020-11-17' limit 1

select * from dibots_v2.exchange_demography_stock_rank where trading_date = '2020-08-25' and board = 'MAIN MARKET' and sector = 'CONSTRUCTION'

select min(trading_date) from dibots_v2.exchange_demography_stock_rank where week_count = '2020-02' 

select * from dibots_v2.exchange_demography_stock_rank where trading_date = '2021-01-21'