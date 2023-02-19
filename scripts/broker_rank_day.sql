--====================
-- BROKER RANK DAY
--===================

--drop table dibots_v2.broker_rank_day;
create table dibots_v2.broker_rank_day (
trading_date date,
week_count varchar(10),
month int,
year int,
qtr int,
external_id int,
participant_code int,
participant_name varchar(255),
total_trade_volume bigint,
total_trade_value numeric(32,5),
total_pct numeric(10,2),
rank_total int,
local_trade_volume bigint,
local_trade_value numeric(32,5),
local_pct numeric(10,2),
rank_local int,
foreign_trade_volume bigint,
foreign_trade_value numeric(32,5),
foreign_pct numeric(10,2),
rank_foreign int,
nominee_total_trade_volume bigint,
nominee_total_trade_value numeric(32,5),
nominee_total_pct numeric(10,2),
rank_nominee_total int,
nominee_local_trade_volume bigint,
nominee_local_trade_value numeric(32,5),
nominee_local_pct numeric(10,2),
rank_nominee_local int,
nominee_foreign_trade_volume bigint,
nominee_foreign_trade_value numeric(32,5),
nominee_foreign_pct numeric(10,2),
rank_nominee_foreign int,
inst_total_trade_volume bigint,
inst_total_trade_value numeric(32,5),
inst_total_pct numeric(10,2),
rank_inst_total int,
inst_local_trade_volume bigint,
inst_local_trade_value numeric(32,5),
inst_local_pct numeric(10,2),
rank_inst_local int,
inst_foreign_trade_volume bigint,
inst_foreign_trade_value numeric(32,5),
inst_foreign_pct numeric(10,2),
rank_inst_foreign int,
retail_total_trade_volume bigint,
retail_total_trade_value numeric(32,5),
retail_total_pct numeric(10,2),
rank_retail_total int,
retail_local_trade_volume bigint,
retail_local_trade_value numeric(32,5),
retail_local_pct numeric(10,2),
rank_retail_local int,
retail_foreign_trade_volume bigint,
retail_foreign_trade_value numeric(32,5),
retail_foreign_pct numeric(10,2),
rank_retail_foreign int,
proprietary_trade_volume bigint,
proprietary_trade_value numeric(32,5),
proprietary_pct numeric(10,2),
rank_proprietary int,
ivt_trade_volume bigint,
ivt_trade_value numeric(32,5),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_trade_volume bigint,
pdt_trade_value numeric(32,5),
pdt_pct numeric(10,2),
rank_pdt int,
algo_count numeric(32,5),
algo_pct numeric(10,2),
rank_algo int,
inet_count numeric(32,5),
inet_pct numeric(10,2),
rank_inet int,
dma_count numeric(32,5),
dma_pct numeric(10,2),
rank_dma int,
brok_count numeric(32,5),
brok_pct numeric(10,2),
rank_brok int,
ord_count bigint,
trd_count bigint,
ot_ratio numeric(32,2),
market_cap numeric(25,3),
ann_velocity numeric(25,2),
buy_vol bigint,
buy_val numeric(32,5),
sell_vol bigint,
sell_val numeric(32,5)
);


alter table dibots_v2.broker_rank_day add constraint broker_rank_day_pk primary key (trading_date, participant_code);

create index broker_rank_day_ext_id_idx on dibots_v2.broker_rank_day (external_id);

select * from dibots_v2.broker_rank_day order by trading_date desc

-- Insertion
insert into dibots_v2.broker_rank_day (trading_date, participant_code, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, 
foreign_trade_volume, foreign_trade_value, nominee_total_trade_volume, nominee_total_trade_value, nominee_local_trade_volume, nominee_local_trade_value, 
nominee_foreign_trade_volume, nominee_foreign_trade_value, inst_total_trade_volume, inst_total_trade_value, inst_local_trade_volume, inst_local_trade_value, 
inst_foreign_trade_volume, inst_foreign_trade_value, retail_total_trade_volume, retail_total_trade_value, retail_local_trade_volume, retail_local_trade_value, 
retail_foreign_trade_volume, retail_foreign_trade_value, proprietary_trade_volume, proprietary_trade_value, ivt_trade_volume, ivt_trade_value, pdt_trade_volume, pdt_trade_value)
select trading_date, participant_code, sum(total_volume), sum(total_value), sum(local_volume), sum(local_value), sum(foreign_volume), sum(foreign_value), 
sum(total_nominees_volume), sum(total_nominees_value), sum(local_nominees_volume), sum(local_nominees_value), sum(foreign_nominees_volume), sum(foreign_nominees_value), 
sum(total_inst_volume), sum(total_inst_value), sum(local_inst_volume), sum(local_inst_value), sum(foreign_inst_volume), sum(foreign_inst_value), sum(total_retail_volume), 
sum(total_retail_value), sum(local_retail_volume), sum(local_retail_value), sum(foreign_retail_volume), sum(foreign_retail_value), sum(prop_volume), sum(prop_value),
sum(ivt_volume), sum(ivt_value), sum(pdt_volume), sum(pdt_value)
from dibots_v2.exchange_demography_stock_broker_group
group by trading_date, participant_code;

-- NAME AND EXTERNAL_ID
update dibots_v2.broker_rank_day a
set 
participant_name = b.participant_name,
external_id = b.external_id
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false;

-- update the week_count
update dibots_v2.broker_rank_day
set week_count = to_char(trading_date, 'IYYY-IW');

-- update the month and year
update dibots_v2.broker_rank_day
set
month = extract(month from trading_date),
year = extract(year from trading_date);

-- update qtr
update dibots_v2.broker_rank_day
set
qtr = case when month in (1,2,3) then 1
		when month in (4,5,6) then 2
		when month in (7,8,9) then 3
		when month in (10,11,12) then 4
		end;

--=======================
-- ALGO DMA INET BROK
--=======================

-- use wp_algo * ord_cnt / 100 to get the algo count
update dibots_v2.broker_rank_day a
set
algo_count = b.wp_algo * b.ord_cnt / 100,
inet_count = b.wp_inet * b.ord_cnt / 100,
dma_count =  b.wp_dma * b.ord_cnt / 100,
brok_count = b.wp_brok * b.ord_cnt / 100,
ord_count = b.ord_cnt,
trd_count = b.trd_cnt,
ot_ratio = b.ot
from dibots_v2.exchange_market_summary b
where a.trading_date = b.trd_date and a.participant_code = b.participant_code and b.board = 'NM';


--===========================
-- MARKET_CAP & ANN_VELOCITY
--===========================

-- annualised trade velocity, total_value / market_capitalization by day * 248
-- market_capitalization values comes from exchange_daily_transaction, this value is the same for the same date

update dibots_v2.broker_rank_day a
set
market_cap = tmp.market_cap
from
(select transaction_date, sum(market_capitalisation) as market_cap
from dibots_v2.exchange_daily_transaction
group by transaction_date) tmp
where a.trading_date = tmp.transaction_date;

update dibots_v2.broker_rank_day
set
ann_velocity = (total_trade_value / 2 ) / market_cap * 248 * 100;


--===============
-- TOTALS TABLES
--===============

--drop table dibots_v2.broker_rank_day_totals;
create table dibots_v2.broker_rank_day_totals (
trading_date date primary key,
total_trade_volume bigint,
total_trade_value numeric(32,5),
local_trade_volume bigint,
local_trade_value numeric(32,5),
local_trade_pct numeric(10,2),
foreign_trade_volume bigint,
foreign_trade_value numeric(32,5),
foreign_trade_pct numeric(10,2),
nominee_total_trade_volume bigint,
nominee_total_trade_value numeric(32,5),
nominee_total_trade_pct numeric(10,2),
nominee_local_trade_volume bigint,
nominee_local_trade_value numeric(32,5),
nominee_local_trade_pct numeric(10,2),
nominee_foreign_trade_volume bigint,
nominee_foreign_trade_value numeric(32,5),
nominee_foreign_trade_pct numeric(10,2),
inst_total_trade_volume bigint,
inst_total_trade_value numeric(32,5),
inst_total_trade_pct numeric(10,2),
inst_local_trade_volume bigint,
inst_local_trade_value numeric(32,5),
inst_local_trade_pct numeric(10,2),
inst_foreign_trade_volume bigint,
inst_foreign_trade_value numeric(32,5),
inst_foreign_trade_pct numeric(10,2),
retail_total_trade_volume bigint,
retail_total_trade_value numeric(32,5),
retail_total_trade_pct numeric(10,2),
retail_local_trade_volume bigint,
retail_local_trade_value numeric(32,5),
retail_local_trade_pct numeric(10,2),
retail_foreign_trade_volume bigint,
retail_foreign_trade_value numeric(32,5),
retail_foreign_trade_pct numeric(10,2),
proprietary_trade_volume bigint,
proprietary_trade_value numeric(32,5),
proprietary_trade_pct numeric(10,2),
ivt_trade_volume bigint,
ivt_trade_value numeric(32,5),
ivt_trade_pct numeric(10,2),
pdt_trade_volume bigint,
pdt_trade_value numeric(32,5),
pdt_trade_pct numeric(10,2),
algo_count numeric(32,5),
algo_pct numeric(10,2),
inet_count numeric(32,5),
inet_pct numeric(10,2),
dma_count numeric(32,5),
dma_pct numeric(10,2),
brok_count numeric(32,5),
brok_pct numeric(10,2),
ord_count bigint,
trd_count bigint,
market_ot_ratio numeric(10,2),
buy_vol bigint,
buy_val numeric(32,5),
sell_vol bigint,
sell_val numeric(32,5)
);

insert into dibots_v2.broker_rank_day_totals (trading_date, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, local_trade_pct, foreign_trade_volume, foreign_trade_value, foreign_trade_pct,
nominee_total_trade_volume, nominee_total_trade_value, nominee_total_trade_pct, nominee_local_trade_volume, nominee_local_trade_value, nominee_local_trade_pct, nominee_foreign_trade_volume, nominee_foreign_trade_value,
nominee_foreign_trade_pct, inst_total_trade_volume, inst_total_trade_value, inst_total_trade_pct, inst_local_trade_volume, inst_local_trade_value, inst_local_trade_pct, inst_foreign_trade_volume, inst_foreign_trade_value,
inst_foreign_trade_pct, retail_total_trade_volume, retail_total_trade_value, retail_total_trade_pct, retail_local_trade_volume, retail_local_trade_value, retail_local_trade_pct, retail_foreign_trade_volume, 
retail_foreign_trade_value, retail_foreign_trade_pct, proprietary_trade_volume, proprietary_trade_value, proprietary_trade_pct, ivt_trade_volume, ivt_trade_value, ivt_trade_pct, pdt_trade_volume, pdt_trade_value,
pdt_trade_pct, algo_count, algo_pct, inet_count, inet_pct, dma_count, dma_pct, brok_count, brok_pct, trd_count, ord_count)
select trading_date, sum(total_trade_volume), sum(total_trade_value), 
sum(local_trade_volume), sum(local_trade_value), sum(local_trade_value) / sum(total_trade_value) * 100,
sum(foreign_trade_volume), sum(foreign_trade_value), sum(foreign_trade_value) / sum(total_trade_value) * 100,
sum(nominee_total_trade_volume), sum(nominee_total_trade_value), sum(nominee_total_trade_value) / sum(total_trade_value) * 100,
sum(nominee_local_trade_volume), sum(nominee_local_trade_value), sum(nominee_local_trade_value) / sum(total_trade_value) * 100,
sum(nominee_foreign_trade_volume), sum(nominee_foreign_trade_value), sum(nominee_foreign_trade_value) / sum(total_trade_value) * 100,
sum(inst_total_trade_volume), sum(inst_total_trade_value), sum(inst_total_trade_value) / sum(total_trade_value) * 100,
sum(inst_local_trade_volume), sum(inst_local_trade_value), sum(inst_local_trade_value) / sum(total_trade_value) * 100,
sum(inst_foreign_trade_volume), sum(inst_foreign_trade_value), sum(inst_foreign_trade_value) / sum(total_trade_value) * 100,
sum(retail_total_trade_volume), sum(retail_total_trade_value), sum(retail_total_trade_value) / sum(total_trade_value) * 100,
sum(retail_local_trade_volume), sum(retail_local_trade_value), sum(retail_local_trade_value) / sum(total_trade_value) * 100,
sum(retail_foreign_trade_volume), sum(retail_foreign_trade_value), sum(retail_foreign_trade_value) / sum(total_trade_value) * 100,
sum(proprietary_trade_volume), sum(proprietary_trade_value), sum(proprietary_trade_value) / sum(total_trade_value) * 100,
sum(ivt_trade_volume), sum(ivt_trade_value), sum(ivt_trade_value) / sum(total_trade_value) * 100,
sum(pdt_trade_volume), sum(pdt_trade_value), sum(pdt_trade_value) / sum(total_trade_value) * 100,
sum(algo_count), sum(algo_count) / cast(sum(ord_count) as numeric) * 100,
sum(inet_count), sum(inet_count) / cast(sum(ord_count) as numeric) * 100,
sum(dma_count), sum(dma_count) / cast(sum(ord_count) as numeric) * 100,
sum(brok_count), sum(brok_count) / cast(sum(ord_count) as numeric) * 100,
sum(trd_count), sum(ord_count)
from dibots_v2.broker_rank_day
group by trading_date;

select * from dibots_v2.broker_rank_day_totals order by trading_date desc

update dibots_v2.broker_rank_day_totals
set
market_ot_ratio = cast(ord_count as numeric) / cast(trd_count as numeric)

--===================================
-- updating the pct columns
--===================================

select a.trading_date, a.participant_code, a.participant_name, a.total_trade_value, b.total_trade_value, a.total_trade_value / b.total_trade_value * 100
from dibots_v2.broker_rank_day a, dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date

update dibots_v2.broker_rank_day a
set
total_pct = a.total_trade_value / b.total_trade_value * 100,
local_pct = a.local_trade_value / b.local_trade_value * 100,
foreign_pct = a.foreign_trade_value / b.foreign_trade_value * 100,
nominee_total_pct = a.nominee_total_trade_value / b.nominee_total_trade_value * 100,
nominee_local_pct = a.nominee_local_trade_value / b.nominee_local_trade_value * 100,
nominee_foreign_pct = a.nominee_foreign_trade_value / b.nominee_foreign_trade_value * 100,
inst_total_pct = a.inst_total_trade_value / b.inst_total_trade_value * 100,
inst_local_pct = a.inst_local_trade_value / b.inst_local_trade_value * 100,
inst_foreign_pct = a.inst_foreign_trade_value / b.inst_foreign_trade_value * 100,
retail_total_pct = a.retail_total_trade_value / b.retail_total_trade_value * 100,
retail_local_pct = a.retail_local_trade_value / b.retail_local_trade_value * 100,
retail_foreign_pct = a.retail_foreign_trade_value / b.retail_foreign_trade_value * 100,
proprietary_pct = a.proprietary_trade_value / b.proprietary_trade_value * 100,
ivt_pct = a.ivt_trade_value / b.ivt_trade_value * 100,
pdt_pct = a.pdt_trade_value / b.pdt_trade_value * 100,
algo_pct = a.algo_count / b.algo_count * 100,
inet_pct = a.inet_count / b.inet_count * 100,
dma_pct = a.dma_count / b.dma_count * 100,
brok_pct = a.brok_count / b.brok_count * 100
from dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date;

select trading_date, sum(total_pct), sum(local_pct), sum(foreign_pct), sum(nominee_total_pct), sum(nominee_local_pct), sum(nominee_foreign_pct), sum(inst_total_pct), sum(inst_local_pct), sum(inst_foreign_pct), 
sum(retail_total_pct), sum(retail_local_pct), sum(retail_foreign_pct), sum(proprietary_pct), sum(ivt_pct), sum(pdt_pct), sum(algo_pct), sum(inet_pct), sum(dma_pct), sum(brok_pct)
from dibots_v2.broker_rank_day
group by trading_date


--========================
-- RANKING
--========================

select trading_date, participant_code, rank() over (partition by trading_date order by total_trade_value desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code, total_trade_value

-- rank_total
update dibots_v2.broker_rank_day a
set
rank_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by total_trade_value desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code, total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_day a
set
rank_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_trade_value desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code, local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_day a
set
rank_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where foreign_trade_value is not null
group by trading_date, participant_code, foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_total
update dibots_v2.broker_rank_day a
set
rank_nominee_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_total_trade_value is not null
group by trading_date, participant_code, nominee_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_local
update dibots_v2.broker_rank_day a
set
rank_nominee_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_local_trade_value is not null
group by trading_date, participant_code, nominee_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_foreign
update dibots_v2.broker_rank_day a
set
rank_nominee_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_foreign_trade_value is not null
group by trading_date, participant_code, nominee_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_total
update dibots_v2.broker_rank_day a
set
rank_inst_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_total_trade_value is not null
group by trading_date, participant_code, inst_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_local
update dibots_v2.broker_rank_day a
set
rank_inst_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_local_trade_value is not null
group by trading_date, participant_code, inst_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_foreign
update dibots_v2.broker_rank_day a
set
rank_inst_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_foreign_trade_value is not null
group by trading_date, participant_code, inst_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_total
update dibots_v2.broker_rank_day a
set
rank_retail_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_total_trade_value is not null
group by trading_date, participant_code, retail_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_local
update dibots_v2.broker_rank_day a
set
rank_retail_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_local_trade_value is not null
group by trading_date, participant_code, retail_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_foreign
update dibots_v2.broker_rank_day a
set
rank_retail_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_foreign_trade_value is not null
group by trading_date, participant_code, retail_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_proprietary
update dibots_v2.broker_rank_day a
set
rank_proprietary = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by proprietary_trade_value desc) rank
from dibots_v2.broker_rank_day
where proprietary_trade_value is not null
group by trading_date, participant_code, proprietary_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_day a
set
rank_ivt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by ivt_trade_value desc) rank
from dibots_v2.broker_rank_day
where ivt_trade_value is not null
group by trading_date, participant_code, ivt_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_day a
set
rank_pdt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by pdt_trade_value desc) rank
from dibots_v2.broker_rank_day
where pdt_trade_value is not null
group by trading_date, participant_code, pdt_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_algo
update dibots_v2.broker_rank_day a
set
rank_algo = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by algo_count desc) rank
from dibots_v2.broker_rank_day
where algo_count is not null
group by trading_date, participant_code, algo_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inet
update dibots_v2.broker_rank_day a
set
rank_inet = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inet_count desc) rank
from dibots_v2.broker_rank_day
where inet_count is not null
group by trading_date, participant_code, inet_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_dma
update dibots_v2.broker_rank_day a
set
rank_dma = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by dma_count desc) rank
from dibots_v2.broker_rank_day
where dma_count is not null
group by trading_date, participant_code, dma_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_brok
update dibots_v2.broker_rank_day a
set
rank_brok = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by brok_count desc) rank
from dibots_v2.broker_rank_day
where brok_count is not null
group by trading_date, participant_code, brok_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

--=======================

select * from dibots_v2.broker_rank_day where trading_date = '2020-06-29'


-- day of the week
select extract(isodow from date '2020-06-24')

-- week count
select to_char(current_date, 'IYYY-IW');

select trading_date, participant_code, participant_name, sum(gross_traded_volume_buy + gross_traded_volume_sell), sum(gross_traded_value_buy + gross_traded_value_sell),
rank() over (order by sum(gross_traded_value_buy + gross_traded_value_sell) desc) rank
from dibots_v2.exchange_demography
where trading_date between '2020-02-03' and '2020-02-04'
group by trading_date, participant_code, participant_name


select trading_date, participant_code, participant_name, ann_velocity
from dibots_v2.broker_rank_day
where trading_date = '2020-07-15'

select transaction_date, sum(value_traded_market_transaction) from dibots_v2.exchange_daily_transaction where transaction_date = '2020-07-15'
group by transaction_date


--================================
--================================
-- INCREMENTAL UPDATE
--================================
--================================

-- insert latest data
insert into dibots_v2.broker_rank_day (trading_date, participant_code, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, 
foreign_trade_volume, foreign_trade_value, nominee_total_trade_volume, nominee_total_trade_value, nominee_local_trade_volume, nominee_local_trade_value, 
nominee_foreign_trade_volume, nominee_foreign_trade_value, inst_total_trade_volume, inst_total_trade_value, inst_local_trade_volume, inst_local_trade_value, 
inst_foreign_trade_volume, inst_foreign_trade_value, retail_total_trade_volume, retail_total_trade_value, retail_local_trade_volume, retail_local_trade_value, 
retail_foreign_trade_volume, retail_foreign_trade_value, proprietary_trade_volume, proprietary_trade_value, ivt_trade_volume, ivt_trade_value, 
pdt_trade_volume, pdt_trade_value, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, participant_code, sum(total_volume), sum(total_value), sum(local_volume), sum(local_value), sum(foreign_volume), sum(foreign_value), 
sum(total_nominees_volume), sum(total_nominees_value), sum(local_nominees_volume), sum(local_nominees_value), sum(foreign_nominees_volume), sum(foreign_nominees_value), 
sum(total_inst_volume), sum(total_inst_value), sum(local_inst_volume), sum(local_inst_value), sum(foreign_inst_volume), sum(foreign_inst_value), sum(total_retail_volume), 
sum(total_retail_value), sum(local_retail_volume), sum(local_retail_value), sum(foreign_retail_volume), sum(foreign_retail_value), sum(prop_volume), sum(prop_value),
sum(ivt_volume), sum(ivt_value), sum(pdt_volume), sum(pdt_value), sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.exchange_demography_stock_broker_group
where trading_date > (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code;

-- Keep the week_count, month and year to the last because the other updates depend on the columns being null
-- update the week_count
update dibots_v2.broker_rank_day
set week_count = to_char(trading_date, 'IYYY-IW')
where week_count is null;

-- update the month and year
update dibots_v2.broker_rank_day
set
month = extract(month from trading_date),
year = extract(year from trading_date)
where month is null;


--=======================
-- ALGO DMA INET BROK
--=======================

-- use wp_algo * ord_cnt / 100 to get the algo count
update dibots_v2.broker_rank_day a
set
algo_count = b.wp_algo * b.ord_cnt / 100,
inet_count = b.wp_inet * b.ord_cnt / 100,
dma_count =  b.wp_dma * b.ord_cnt / 100,
brok_count = b.wp_brok * b.ord_cnt / 100,
ord_count = b.ord_cnt,
trd_count = b.trd_cnt,
ot_ratio = b.ot
from dibots_v2.exchange_market_summary b
where a.trading_date = b.trd_date and a.participant_code = b.participant_code and b.board = 'NM' and a.trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day);


--===========================
-- MARKET_CAP & ANN_VELOCITY
--===========================

-- annualised trade velocity, total_value / market_capitalization by day * 248
-- market_capitalization values comes from exchange_daily_transaction, this value is the same for the same date

update dibots_v2.broker_rank_day a
set
market_cap = tmp.market_cap
from
(select transaction_date, sum(market_capitalisation) as market_cap
from dibots_v2.exchange_daily_transaction
where transaction_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by transaction_date) tmp
where a.trading_date = tmp.transaction_date;

update dibots_v2.broker_rank_day
set
ann_velocity = (total_trade_value / 2 ) / market_cap * 248 * 100
where ann_velocity is null;



--===================================
--Insert the totals to the tmp table
--===================================

insert into dibots_v2.broker_rank_day_totals (trading_date, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, local_trade_pct, foreign_trade_volume, foreign_trade_value, foreign_trade_pct,
nominee_total_trade_volume, nominee_total_trade_value, nominee_total_trade_pct, nominee_local_trade_volume, nominee_local_trade_value, nominee_local_trade_pct, nominee_foreign_trade_volume, nominee_foreign_trade_value,
nominee_foreign_trade_pct, inst_total_trade_volume, inst_total_trade_value, inst_total_trade_pct, inst_local_trade_volume, inst_local_trade_value, inst_local_trade_pct, inst_foreign_trade_volume, inst_foreign_trade_value,
inst_foreign_trade_pct, retail_total_trade_volume, retail_total_trade_value, retail_total_trade_pct, retail_local_trade_volume, retail_local_trade_value, retail_local_trade_pct, retail_foreign_trade_volume, 
retail_foreign_trade_value, retail_foreign_trade_pct, proprietary_trade_volume, proprietary_trade_value, proprietary_trade_pct, ivt_trade_volume, ivt_trade_value, ivt_trade_pct, pdt_trade_volume, pdt_trade_value,
pdt_trade_pct, algo_count, algo_pct, inet_count, inet_pct, dma_count, dma_pct, brok_count, brok_pct, trd_count, ord_count, buy_vol, buy_val, sell_vol, sell_val)
select trading_date, sum(total_trade_volume), sum(total_trade_value), 
sum(local_trade_volume), sum(local_trade_value), sum(local_trade_value) / sum(total_trade_value) * 100,
sum(foreign_trade_volume), sum(foreign_trade_value), sum(foreign_trade_value) / sum(total_trade_value) * 100,
sum(nominee_total_trade_volume), sum(nominee_total_trade_value), sum(nominee_total_trade_value) / sum(total_trade_value) * 100,
sum(nominee_local_trade_volume), sum(nominee_local_trade_value), sum(nominee_local_trade_value) / sum(total_trade_value) * 100,
sum(nominee_foreign_trade_volume), sum(nominee_foreign_trade_value), sum(nominee_foreign_trade_value) / sum(total_trade_value) * 100,
sum(inst_total_trade_volume), sum(inst_total_trade_value), sum(inst_total_trade_value) / sum(total_trade_value) * 100,
sum(inst_local_trade_volume), sum(inst_local_trade_value), sum(inst_local_trade_value) / sum(total_trade_value) * 100,
sum(inst_foreign_trade_volume), sum(inst_foreign_trade_value), sum(inst_foreign_trade_value) / sum(total_trade_value) * 100,
sum(retail_total_trade_volume), sum(retail_total_trade_value), sum(retail_total_trade_value) / sum(total_trade_value) * 100,
sum(retail_local_trade_volume), sum(retail_local_trade_value), sum(retail_local_trade_value) / sum(total_trade_value) * 100,
sum(retail_foreign_trade_volume), sum(retail_foreign_trade_value), sum(retail_foreign_trade_value) / sum(total_trade_value) * 100,
sum(proprietary_trade_volume), sum(proprietary_trade_value), sum(proprietary_trade_value) / sum(total_trade_value) * 100,
sum(ivt_trade_volume), sum(ivt_trade_value), sum(ivt_trade_value) / sum(total_trade_value) * 100,
sum(pdt_trade_volume), sum(pdt_trade_value), sum(pdt_trade_value) / sum(total_trade_value) * 100,
sum(algo_count), sum(algo_count) / cast(sum(ord_count) as numeric) * 100,
sum(inet_count), sum(inet_count) / cast(sum(ord_count) as numeric) * 100,
sum(dma_count), sum(dma_count) / cast(sum(ord_count) as numeric) * 100,
sum(brok_count), sum(brok_count) / cast(sum(ord_count) as numeric) * 100,
sum(trd_count), sum(ord_count), sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.broker_rank_day
where trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date;

--==================
-- market_ot_ratio
--==================
update dibots_v2.broker_rank_day_totals
set
market_ot_ratio = cast(ord_count as numeric) / cast(trd_count as numeric)
where trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day);

--========================
--update pct
--========================

update dibots_v2.broker_rank_day a
set
total_pct = a.total_trade_value / b.total_trade_value * 100,
local_pct = a.local_trade_value / b.local_trade_value * 100,
foreign_pct = a.foreign_trade_value / b.foreign_trade_value * 100,
nominee_total_pct = a.nominee_total_trade_value / b.nominee_total_trade_value * 100,
nominee_local_pct = a.nominee_local_trade_value / b.nominee_local_trade_value * 100,
nominee_foreign_pct = a.nominee_foreign_trade_value / b.nominee_foreign_trade_value * 100,
inst_total_pct = a.inst_total_trade_value / b.inst_total_trade_value * 100,
inst_local_pct = a.inst_local_trade_value / b.inst_local_trade_value * 100,
inst_foreign_pct = a.inst_foreign_trade_value / b.inst_foreign_trade_value * 100,
retail_total_pct = a.retail_total_trade_value / b.retail_total_trade_value * 100,
retail_local_pct = a.retail_local_trade_value / b.retail_local_trade_value * 100,
retail_foreign_pct = a.retail_foreign_trade_value / b.retail_foreign_trade_value * 100,
proprietary_pct = a.proprietary_trade_value / b.proprietary_trade_value * 100,
ivt_pct = a.ivt_trade_value / b.ivt_trade_value * 100,
pdt_pct = a.pdt_trade_value / b.pdt_trade_value * 100,
algo_pct = a.algo_count / b.algo_count * 100,
inet_pct = a.inet_count / b.inet_count * 100,
dma_pct = a.dma_count / b.dma_count * 100,
brok_pct = a.brok_count / b.brok_count * 100
buy_vol_pct = a.buy_vol / b.buy_vol * 100,
buy_val_pct = a.buy_val / b.buy_val * 100,
sell_vol_pct = a.sell_vol / b.sell_vol * 100,
sell_val_pct = a.sell_val / b.sell_val * 100
from dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date and a.trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day);

--========================
--ranking for each day
--========================

-- rank_total
update dibots_v2.broker_rank_day a
set
rank_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by total_trade_value desc) rank
from dibots_v2.broker_rank_day
where trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_day a
set
rank_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_trade_value desc) rank
from dibots_v2.broker_rank_day
where local_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_day a
set
rank_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where foreign_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_total
update dibots_v2.broker_rank_day a
set
rank_nominee_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_total_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, nominee_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_local
update dibots_v2.broker_rank_day a
set
rank_nominee_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_local_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, nominee_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominee_foreign
update dibots_v2.broker_rank_day a
set
rank_nominee_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominee_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where nominee_foreign_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, nominee_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_total
update dibots_v2.broker_rank_day a
set
rank_inst_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_total_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, inst_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_local
update dibots_v2.broker_rank_day a
set
rank_inst_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_local_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, inst_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst_foreign
update dibots_v2.broker_rank_day a
set
rank_inst_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where inst_foreign_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, inst_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_total
update dibots_v2.broker_rank_day a
set
rank_retail_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_total_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_total_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, retail_total_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_local
update dibots_v2.broker_rank_day a
set
rank_retail_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_local_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_local_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, retail_local_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail_foreign
update dibots_v2.broker_rank_day a
set
rank_retail_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_foreign_trade_value desc) rank
from dibots_v2.broker_rank_day
where retail_foreign_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, retail_foreign_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_proprietary
update dibots_v2.broker_rank_day a
set
rank_proprietary = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by proprietary_trade_value desc) rank
from dibots_v2.broker_rank_day
where proprietary_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, proprietary_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_day a
set
rank_ivt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by ivt_trade_value desc) rank
from dibots_v2.broker_rank_day
where ivt_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, ivt_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_day a
set
rank_pdt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by pdt_trade_value desc) rank
from dibots_v2.broker_rank_day
where pdt_trade_value is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, pdt_trade_value) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_algo
update dibots_v2.broker_rank_day a
set
rank_algo = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by algo_count desc) rank
from dibots_v2.broker_rank_day
where algo_count is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, algo_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inet
update dibots_v2.broker_rank_day a
set
rank_inet = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inet_count desc) rank
from dibots_v2.broker_rank_day
where inet_count is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, inet_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_dma
update dibots_v2.broker_rank_day a
set
rank_dma = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by dma_count desc) rank
from dibots_v2.broker_rank_day
where dma_count is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, dma_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_brok
update dibots_v2.broker_rank_day a
set
rank_brok = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by brok_count desc) rank
from dibots_v2.broker_rank_day
where brok_count is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code, brok_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_buy_vol
update dibots_v2.broker_rank_day a
set
rank_buy_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_vol desc) rank
from dibots_v2.broker_rank_day
where buy_vol is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_buy_val
update dibots_v2.broker_rank_day a
set
rank_buy_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_val desc) rank
from dibots_v2.broker_rank_day
where buy_val is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_sell_vol
update dibots_v2.broker_rank_day a
set
rank_sell_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_vol desc) rank
from dibots_v2.broker_rank_day
where sell_vol is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_sell_val
update dibots_v2.broker_rank_day a
set
rank_sell_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_val desc) rank
from dibots_v2.broker_rank_day
where sell_val is not null and trading_date >= (select max(trading_date) from dibots_v2.broker_rank_day)
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;