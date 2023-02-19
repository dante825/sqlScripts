--=========================
-- BROKER_RANK_OMTDBT_DAY
--=========================
-- For broker omt + dbt data

--drop table dibots_v2.broker_rank_omtdbt_day;
create table dibots_v2.broker_rank_omtdbt_day (
trading_date date,
week_count varchar(10),
month int,
year int,
qtr int,
external_id int,
participant_code int,
participant_name varchar(255),
total_vol bigint,
total_val numeric(25,3),
total_pct numeric(10,2),
rank_total int,
local_vol bigint,
local_val numeric(25,3),
local_pct numeric(10,2),
rank_local int,
foreign_vol bigint,
foreign_val numeric(25,3),
foreign_pct numeric(10,2),
rank_foreign int,
inst_vol bigint,
inst_val numeric(25,3),
inst_pct numeric(10,2),
rank_inst int,
local_inst_vol bigint,
local_inst_val numeric(25,3),
local_inst_pct numeric(10,2),
rank_local_inst int,
foreign_inst_vol bigint,
foreign_inst_val numeric(25,3),
foreign_inst_pct numeric(10,2),
rank_foreign_inst int,
retail_vol bigint,
retail_val numeric(25,3),
retail_pct numeric(10,2),
rank_retail int,
local_retail_vol bigint,
local_retail_val numeric(25,3),
local_retail_pct numeric(10,2),
rank_local_retail int,
foreign_retail_vol bigint,
foreign_retail_val numeric(25,3),
foreign_retail_pct numeric(10,2),
rank_foreign_retail int,
nominees_vol bigint,
nominees_val numeric(25,3),
nominees_pct numeric(10,2),
rank_nominees int,
local_nominees_vol bigint,
local_nominees_val numeric(25,3),
local_nominees_pct numeric(10,2),
rank_local_nominees int,
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,3),
foreign_nominees_pct numeric(10,2),
rank_foreign_nominees int,
prop_vol bigint,
prop_val numeric(25,3),
prop_pct numeric(10,2),
rank_prop int,
ivt_vol bigint,
ivt_val numeric(25,3),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_vol bigint,
pdt_val numeric(25,3),
pdt_pct numeric(10,2),
rank_pdt int,
algo_count numeric(25,2),
algo_pct numeric(10,2),
rank_algo int,
inet_count numeric(25,2),
inet_pct numeric(10,2),
rank_inet int,
dma_count numeric(25,2),
dma_pct numeric(10,2),
rank_dma int,
brok_count numeric(25,2),
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

alter table dibots_v2.broker_rank_omtdbt_day add constraint broker_rank_od_day_pk primary key (trading_date, participant_code);
create index broker_rank_od_day_ext_id_idx on dibots_v2.broker_rank_omtdbt_day (external_id);

select * from dibots_v2.broker_rank_omtdbt_day order by trading_date desc

-- INSERTION (OMT + DBT)
insert into dibots_v2.broker_rank_omtdbt_day (trading_date, participant_code, total_vol, total_val, 
local_vol, local_val, foreign_vol, foreign_val, 
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, 
retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val,
prop_vol, prop_val, ivt_vol, ivt_val, pdt_vol, pdt_val)
select a.trading_date, a.participant_code, 
sum(a.total_vol), sum(a.total_val), sum(a.local_vol), sum(a.local_val), sum(a.foreign_vol), sum(a.foreign_val),
sum(a.inst_vol), sum(a.inst_val), sum(a.local_inst_vol), sum(a.local_inst_val), sum(a.foreign_inst_vol), sum(a.foreign_inst_val), 
sum(a.retail_vol), sum(a.retail_val),sum(a.local_retail_vol), sum(a.local_retail_val),sum(a.foreign_retail_vol), sum(a.foreign_retail_val),
sum(a.nominees_vol), sum(a.nominees_val),sum(a.local_nominees_vol), sum(a.local_nominees_val),sum(a.foreign_nominees_vol), 
sum(a.foreign_nominees_val),sum(a.prop_vol), sum(a.prop_val),sum(a.ivt_vol), sum(a.ivt_val),
sum(a.pdt_vol), sum(a.pdt_val)
from dibots_v2.exchange_omtdbt_stock_broker_group a 
group by a.trading_date, a.external_id, a.participant_code;

-- INSERT THE OMT DATA
insert into dibots_v2.broker_rank_omtdbt_day (trading_date, week_count, month, year, qtr, external_id, participant_code, participant_name, 
total_vol, total_val, total_pct, rank_total, 
local_vol, local_val, local_pct, rank_local, 
foreign_vol, foreign_val, foreign_pct, rank_foreign,
inst_vol, inst_val, inst_pct, rank_inst, 
local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, 
foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst, 
retail_vol, retail_val, retail_pct, rank_retail, 
local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail, 
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail, 
nominees_vol, nominees_val, nominees_pct, rank_nominees, 
local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees, 
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees, 
prop_vol, prop_val, prop_pct, rank_prop, 
ivt_vol, ivt_val, ivt_pct, rank_ivt, 
pdt_vol, pdt_val, pdt_pct, rank_pdt, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet, 
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok,
ord_count, trd_count, ot_ratio, market_cap, ann_velocity, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val)
select trading_date, week_count, month, year, qtr, external_id, participant_code, participant_name, 
total_trade_volume, total_trade_value, total_pct, rank_total, 
local_trade_volume, local_trade_value, local_pct, rank_local, 
foreign_trade_volume, foreign_trade_value, foreign_pct, rank_foreign,
inst_total_trade_volume, inst_total_trade_value, inst_total_pct, rank_inst_total, 
inst_local_trade_volume, inst_local_trade_value, inst_local_pct, rank_inst_local, 
inst_foreign_trade_volume, inst_foreign_trade_value, inst_foreign_pct, rank_inst_foreign, 
retail_total_trade_volume, retail_total_trade_value, retail_total_pct, rank_retail_total, 
retail_local_trade_volume, retail_local_trade_value, retail_local_pct, rank_retail_local, 
retail_foreign_trade_volume, retail_foreign_trade_value, retail_foreign_pct, rank_retail_foreign, 
nominee_total_trade_volume, nominee_total_trade_value, nominee_total_pct, rank_nominee_total, 
nominee_local_trade_volume, nominee_local_trade_value, nominee_local_pct, rank_nominee_local, 
nominee_foreign_trade_volume, nominee_foreign_trade_value, nominee_foreign_pct, rank_nominee_foreign, 
proprietary_trade_volume, proprietary_trade_value, proprietary_pct, rank_proprietary, 
ivt_trade_volume, ivt_trade_value, ivt_pct, rank_ivt, 
pdt_trade_volume, pdt_trade_value, pdt_pct, rank_pdt, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet, 
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok,
ord_count, trd_count, ot_ratio, market_cap, ann_velocity, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val
from dibots_v2.broker_rank_day
where trading_date < '2020-01-01'


-- update participant_name
update dibots_v2.broker_rank_omtdbt_day a
set
external_id = b.external_id,
participant_name = b.participant_name
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false;

-- Get the ALGOs from broker_rank_day table
update dibots_v2.broker_rank_omtdbt_day a
set
algo_count = b.algo_count,
algo_pct = b.algo_pct,
rank_algo = b.rank_algo,
inet_count = b.inet_count,
inet_pct = b.inet_pct,
rank_inet = b.rank_inet,
dma_count = b.dma_count,
dma_pct = b.dma_pct,
rank_dma = b.rank_dma,
brok_count = b.brok_count,
brok_pct = b.brok_pct,
rank_brok = b.rank_brok,
ord_count = b.ord_count,
trd_count = b.trd_count,
ot_ratio = b.ot_ratio,
market_cap = b.market_cap,
ann_velocity = b.ann_velocity
from dibots_v2.broker_rank_day b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

-- UPDATE WEEK COUNT
update dibots_v2.broker_rank_omtdbt_day
set week_count = to_char(trading_date, 'IYYY-IW');

-- UPDATE MONTH AND YEAR
update dibots_v2.broker_rank_omtdbt_day
set
month = extract(month from trading_date),
year = extract(year from trading_date);

-- UPDATE QTR
update dibots_v2.broker_rank_omtdbt_day
set
qtr = case when month in (1,2,3) then 1
		when month in (4,5,6) then 2
		when month in (7,8,9) then 3
		when month in (10,11,12) then 4
		end;


--===============
-- TOTALS TABLES
--===============

--drop table dibots_v2.broker_rank_omtdbt_day_totals;
create table dibots_v2.broker_rank_omtdbt_day_totals (
trading_date date primary key,
total_vol bigint,
total_val numeric(25,3),
local_vol bigint,
local_val numeric(25,3),
local_pct numeric(10,2),
foreign_vol bigint,
foreign_val numeric(25,3),
foreign_pct numeric(10,2),
inst_vol bigint,
inst_val numeric(25,3),
inst_pct numeric(10,2),
local_inst_vol bigint,
local_inst_val numeric(25,3),
local_inst_pct numeric(10,2),
foreign_inst_vol bigint,
foreign_inst_val numeric(25,3),
foreign_inst_pct numeric(10,2),
retail_vol bigint,
retail_val numeric(25,3),
retail_pct numeric(10,2),
local_retail_vol bigint,
local_retail_val numeric(25,3),
local_retail_pct numeric(10,2),
foreign_retail_vol bigint,
foreign_retail_val numeric(25,3),
foreign_retail_pct numeric(10,2),
nominees_vol bigint,
nominees_val numeric(25,3),
nominees_pct numeric(10,2),
local_nominees_vol bigint,
local_nominees_val numeric(25,3),
local_nominees_pct numeric(10,2),
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,3),
foreign_nominees_pct numeric(10,2),
prop_vol bigint,
prop_val numeric(25,3),
prop_pct numeric(10,2),
ivt_vol bigint,
ivt_val numeric(25,3),
ivt_pct numeric(10,2),
pdt_vol bigint,
pdt_val numeric(25,3),
pdt_pct numeric(10,2),
algo_count numeric(25,5),
algo_pct numeric(10,2),
inet_count numeric(25,5),
inet_pct numeric(10,2),
dma_count numeric(25,5),
dma_pct numeric(10,2),
brok_count numeric(25,5),
brok_pct numeric(10,2),
ord_count bigint,
trd_count bigint,
market_ot_ratio numeric(10,2),
buy_vol bigint,
buy_val numeric(32,5),
sell_vol bigint,
sell_val numeric(32,5)
);

insert into dibots_v2.broker_rank_omtdbt_day_totals (trading_date, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select trading_date, sum(total_vol), sum(total_val), 
sum(local_vol), sum(local_val), sum(local_val) / sum(total_val) * 100, 
sum(foreign_vol), sum(foreign_val), sum(foreign_val) / sum(total_val) * 100,
sum(inst_vol), sum(inst_val), sum(inst_val) / sum(total_val) * 100, 
sum(local_inst_vol), sum(local_inst_val), sum(local_inst_val) / sum(total_val) * 100,
sum(foreign_inst_vol), sum(foreign_inst_val), sum(foreign_inst_val) / sum(total_val) * 100,
sum(retail_vol), sum(retail_val), sum(retail_val) / sum(total_val) * 100,
sum(local_retail_vol), sum(local_retail_val), sum(local_retail_val) / sum(total_val) * 100,
sum(foreign_retail_vol), sum(foreign_retail_val), sum(foreign_retail_val) / sum(total_val) * 100,
sum(nominees_vol), sum(nominees_val), sum(nominees_val) / sum(total_val) * 100,
sum(local_nominees_vol), sum(local_nominees_val), sum(local_nominees_val) / sum(total_val) * 100,
sum(foreign_nominees_vol), sum(foreign_nominees_val), sum(foreign_nominees_val) / sum(total_val) * 100,
sum(prop_vol), sum(prop_val), sum(prop_val) / sum(total_val) * 100,
sum(ivt_vol), sum(ivt_val), sum(ivt_val) / sum(total_val) * 100,
sum(pdt_vol), sum(pdt_val), sum(pdt_val) / sum(total_val) * 100
from dibots_v2.broker_rank_omtdbt_day
group by trading_date;


-- INSERT OMT into the table
insert into dibots_v2.broker_rank_omtdbt_day_totals (trading_date, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select trading_date, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, local_trade_pct, foreign_trade_volume, foreign_trade_value, foreign_trade_pct, 
inst_total_trade_volume, inst_total_trade_value, inst_total_trade_pct,
inst_local_trade_volume, inst_local_trade_value, inst_local_trade_pct, 
inst_foreign_trade_volume, inst_foreign_trade_value, inst_foreign_trade_pct, 
retail_total_trade_volume, retail_total_trade_value, retail_total_trade_pct, 
retail_local_trade_volume, retail_local_trade_value, retail_local_trade_pct,
retail_foreign_trade_volume, retail_foreign_trade_value, retail_foreign_trade_pct, 
nominee_total_trade_volume, nominee_total_trade_value, nominee_total_trade_pct, 
nominee_local_trade_volume, nominee_local_trade_value, nominee_local_trade_pct, 
nominee_foreign_trade_volume, nominee_foreign_trade_value, nominee_foreign_trade_pct, 
proprietary_trade_volume, proprietary_trade_value, proprietary_trade_pct, 
ivt_trade_volume, ivt_trade_value, ivt_trade_pct, 
pdt_trade_volume, pdt_trade_value, pdt_trade_pct
from dibots_v2.broker_rank_day_totals
where trading_date < '2020-01-01';


update dibots_v2.broker_rank_omtdbt_day_totals a
set
algo_count = b.algo_count,
algo_pct = b.algo_pct,
inet_count = b.inet_count,
inet_pct  = b.inet_pct,
dma_count = b.dma_count,
dma_pct = b.dma_pct,
brok_count = b.brok_count,
brok_pct = b.brok_pct,
ord_count = b.ord_count,
trd_count = b.trd_count,
market_ot_ratio = b.market_ot_ratio
from dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date and a.algo_count is null;


--UPDATE PCT COLUMNS
update dibots_v2.broker_rank_omtdbt_day a
set
total_pct = a.total_val / b.total_val * 100,
local_pct = a.local_val / b.local_val * 100,
foreign_pct = a.foreign_val / b.foreign_val * 100,
inst_pct = a.inst_val / b.inst_val * 100,
local_inst_pct = a.local_inst_val / b.local_inst_val * 100,
foreign_inst_pct = a.foreign_inst_val / b.foreign_inst_val * 100,
retail_pct = a.retail_val / b.retail_val * 100,
local_retail_pct = a.local_retail_val / b.local_retail_val * 100,
foreign_retail_pct = a.foreign_retail_val / b.foreign_retail_val * 100,
nominees_pct = a.nominees_val / b.nominees_val * 100,
local_nominees_pct = a.local_nominees_val / b.local_nominees_val * 100,
foreign_nominees_pct = a.foreign_nominees_val / b.foreign_nominees_val * 100,
prop_pct = a.prop_val / b.prop_val * 100,
ivt_pct = a.ivt_val / b.ivt_val * 100,
pdt_pct = a.pdt_val / b.pdt_val * 100
from dibots_v2.broker_rank_omtdbt_day_totals b
where a.trading_date = b.trading_date;

select trading_date, sum(total_pct), sum(local_pct), sum(foreign_pct), sum(nominees_pct), sum(local_nominees_pct), sum(foreign_nominees_pct), sum(inst_pct), sum(local_inst_pct), sum(foreign_inst_pct), 
sum(retail_pct), sum(local_retail_pct), sum(foreign_retail_pct), sum(prop_pct), sum(ivt_pct), sum(pdt_pct)
from dibots_v2.broker_rank_omtdbt_day
group by trading_date;


--========================
-- RANKING
--========================

select trading_date, participant_code, rank() over (partition by trading_date order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code, total_val

-- rank_total
update dibots_v2.broker_rank_omtdbt_day a
set
rank_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code, total_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_val <> 0
group by trading_date, participant_code, local_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_val <> 0
group by trading_date, participant_code, foreign_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where inst_val <> 0
group by trading_date, participant_code, inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_inst_val <> 0
group by trading_date, participant_code, local_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_inst_val <> 0
group by trading_date, participant_code, foreign_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where retail_val <> 0
group by trading_date, participant_code, retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_retail_val <> 0
group by trading_date, participant_code, local_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_retail_val <> 0
group by trading_date, participant_code, foreign_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_day a
set
rank_prop = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where prop_val <> 0
group by trading_date, participant_code, prop_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_day a
set
rank_ivt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where ivt_val <> 0
group by trading_date, participant_code, ivt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_day a
set
rank_pdt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where pdt_val <> 0
group by trading_date, participant_code, pdt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where nominees_val <> 0
group by trading_date, participant_code, nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_nominees_val <> 0
group by trading_date, participant_code, local_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_nominees_val <> 0
group by trading_date, participant_code, foreign_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

--===========================
--===========================
-- INCREMENTAL UPDATE
--===========================
--===========================

-- broker_rank_omtdbt_day table
insert into dibots_v2.broker_rank_omtdbt_day (trading_date, external_id, participant_code, participant_name, total_vol, total_val, 
local_vol, local_val, foreign_vol, foreign_val, 
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, 
retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val,
prop_vol, prop_val, ivt_vol, ivt_val, pdt_vol, pdt_val)
select a.trading_date, a.external_id, a.participant_code, a.participant_name, 
sum(a.total_vol), sum(a.total_val), sum(a.local_vol), sum(a.local_val), sum(a.foreign_vol), sum(a.foreign_val),
sum(a.inst_vol), sum(a.inst_val), sum(a.local_inst_vol), sum(a.local_inst_val), sum(a.foreign_inst_vol), sum(a.foreign_inst_val), 
sum(a.retail_vol), sum(a.retail_val),sum(a.local_retail_vol), sum(a.local_retail_val),sum(a.foreign_retail_vol), sum(a.foreign_retail_val),
sum(a.nominees_vol), sum(a.nominees_val),sum(a.local_nominees_vol), sum(a.local_nominees_val),sum(a.foreign_nominees_vol), 
sum(a.foreign_nominees_val),sum(a.prop_vol), sum(a.prop_val),sum(a.ivt_vol), sum(a.ivt_val),
sum(a.pdt_vol), sum(a.pdt_val)
from dibots_v2.exchange_omtdbt_stock_broker_group a 
where a.trading_date > (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by a.trading_date, a.external_id, a.participant_code, a.participant_name;


-- UPDATE WEEK COUNT
update dibots_v2.broker_rank_omtdbt_day
set week_count = to_char(trading_date, 'IYYY-IW')
where week_count is null;

-- UPDATE MONTH AND YEAR
update dibots_v2.broker_rank_omtdbt_day
set
month = extract(month from trading_date),
year = extract(year from trading_date)
where month is null;

-- UPDATE QTR
update dibots_v2.broker_rank_omtdbt_day
set
qtr = case when month in (1,2,3) then 1
		when month in (4,5,6) then 2
		when month in (7,8,9) then 3
		when month in (10,11,12) then 4
		end
where qtr is null;

-- Get the ALGOs from broker_rank_day table
update dibots_v2.broker_rank_omtdbt_day a
set
algo_count = b.algo_count,
algo_pct = b.algo_pct,
rank_algo = b.rank_algo,
inet_count = b.inet_count,
inet_pct = b.inet_pct,
rank_inet = b.rank_inet,
dma_count = b.dma_count,
dma_pct = b.dma_pct,
rank_dma = b.rank_dma,
brok_count = b.brok_count,
brok_pct = b.brok_pct,
rank_brok = b.rank_brok,
ord_count = b.ord_count,
trd_count = b.trd_count,
ot_ratio = b.ot_ratio,
market_cap = b.market_cap,
ann_velocity = b.ann_velocity
from dibots_v2.broker_rank_day b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code and a.trading_date >= '?'


-- broker_rank_omtdbt_day_totals
insert into dibots_v2.broker_rank_omtdbt_day_totals (trading_date, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select trading_date, sum(total_vol), sum(total_val), 
sum(local_vol), sum(local_val), sum(local_val) / sum(total_val) * 100, 
sum(foreign_vol), sum(foreign_val), sum(foreign_val) / sum(total_val) * 100,
sum(inst_vol), sum(inst_val), sum(inst_val) / sum(total_val) * 100, 
sum(local_inst_vol), sum(local_inst_val), sum(local_inst_val) / sum(total_val) * 100,
sum(foreign_inst_vol), sum(foreign_inst_val), sum(foreign_inst_val) / sum(total_val) * 100,
sum(retail_vol), sum(retail_val), sum(retail_val) / sum(total_val) * 100,
sum(local_retail_vol), sum(local_retail_val), sum(local_retail_val) / sum(total_val) * 100,
sum(foreign_retail_vol), sum(foreign_retail_val), sum(foreign_retail_val) / sum(total_val) * 100,
sum(nominees_vol), sum(nominees_val), sum(nominees_val) / sum(total_val) * 100,
sum(local_nominees_vol), sum(local_nominees_val), sum(local_nominees_val) / sum(total_val) * 100,
sum(foreign_nominees_vol), sum(foreign_nominees_val), sum(foreign_nominees_val) / sum(total_val) * 100,
sum(prop_vol), sum(prop_val), sum(prop_val) / sum(total_val) * 100,
sum(ivt_vol), sum(ivt_val), sum(ivt_val) / sum(total_val) * 100,
sum(pdt_vol), sum(pdt_val), sum(pdt_val) / sum(total_val) * 100
from dibots_v2.broker_rank_omtdbt_day
where trading_date > (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day_totals)
group by trading_date;

update dibots_v2.broker_rank_omtdbt_day_totals a
set
algo_count = b.algo_count,
algo_pct = b.algo_pct,
inet_count = b.inet_count,
inet_pct  = b.inet_pct,
dma_count = b.dma_count,
dma_pct = b.dma_pct,
brok_count = b.brok_count,
brok_pct = b.brok_pct,
ord_count = b.ord_count,
trd_count = b.trd_count,
market_ot_ratio = b.market_ot_ratio
from dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date and a.algo_count is null;


--UPDATE PCT COLUMNS
update dibots_v2.broker_rank_omtdbt_day a
set
total_pct = a.total_val / b.total_val * 100,
local_pct = a.local_val / b.local_val * 100,
foreign_pct = a.foreign_val / b.foreign_val * 100,
inst_pct = a.inst_val / b.inst_val * 100,
local_inst_pct = a.local_inst_val / b.local_inst_val * 100,
foreign_inst_pct = a.foreign_inst_val / b.foreign_inst_val * 100,
retail_pct = a.retail_val / b.retail_val * 100,
local_retail_pct = a.local_retail_val / b.local_retail_val * 100,
foreign_retail_pct = a.foreign_retail_val / b.foreign_retail_val * 100,
nominees_pct = a.nominees_val / b.nominees_val * 100,
local_nominees_pct = a.local_nominees_val / b.local_nominees_val * 100,
foreign_nominees_pct = a.foreign_nominees_val / b.foreign_nominees_val * 100,
prop_pct = a.prop_val / b.prop_val * 100,
ivt_pct = a.ivt_val / b.ivt_val * 100,
pdt_pct = a.pdt_val / b.pdt_val * 100
from dibots_v2.broker_rank_omtdbt_day_totals b
where a.trading_date = b.trading_date and trading_date > '?'
--and a.total_pct is null;

--========================
-- RANKING
--========================

select trading_date, participant_code, rank() over (partition by trading_date order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code, total_val

-- rank_total
update dibots_v2.broker_rank_omtdbt_day a
set
rank_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, total_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, local_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, foreign_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where inst_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_inst_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, local_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_inst_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, foreign_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where retail_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_retail_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, local_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_retail_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, foreign_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where nominees_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_local_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where local_nominees_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, local_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_day a
set
rank_foreign_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where foreign_nominees_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, foreign_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_day a
set
rank_prop = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where prop_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, prop_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_day a
set
rank_ivt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where ivt_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, ivt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_day a
set
rank_pdt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
where pdt_val <> 0 and trading_date = (select max(trading_date) from dibots_v2.broker_rank_omtdbt_day)
group by trading_date, participant_code, pdt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;