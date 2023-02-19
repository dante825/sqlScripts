--===========================
-- BROKER_RANK_OMTDBT_YEAR
--===========================
-- the data should be derived from broker_rank_omtdbt_day

--drop table dibots_v2.broker_rank_omtdbt_year;
create table dibots_v2.broker_rank_omtdbt_year (
year int,
trading_day_count int,
external_id bigint,
participant_code int,
participant_name varchar(100),
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
ot_ratio numeric(25,2),
market_cap numeric(25,3),
ann_velocity numeric(25,2),
buy_vol bigint,
buy_val numeric(32,5),
sell_vol bigint,
sell_val numeric(32,5)
);

alter table dibots_v2.broker_rank_omtdbt_year add constraint broker_rank_omtdbt_year_pk primary key (year, participant_code);
create index broker_rank_omtdbt_year_ext_id_idx on dibots_v2.broker_rank_omtdbt_year (external_id);

select * from dibots_v2.broker_rank_omtdbt_year order by year desc

-- FRESH INSERT
insert into dibots_v2.broker_rank_omtdbt_year(year, participant_code, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, prop_vol, prop_val, ivt_vol, ivt_val, pdt_vol, pdt_val)
select year, participant_code, sum(total_vol), sum(total_val), sum(local_vol), sum(local_val), sum(foreign_vol), sum(foreign_val),
sum(inst_vol), sum(inst_val), sum(local_inst_vol), sum(local_inst_val), sum(foreign_inst_vol), sum(foreign_inst_val), sum(retail_vol), sum(retail_val), sum(local_retail_vol), sum(local_retail_val), 
sum(foreign_retail_vol), sum(foreign_retail_val), sum(nominees_vol), sum(nominees_val), sum(local_nominees_vol), sum(local_nominees_val), sum(foreign_nominees_vol), sum(foreign_nominees_val),
sum(prop_vol), sum(prop_val), sum(ivt_vol), sum(ivt_val), sum(pdt_vol), sum(pdt_val)
from dibots_v2.broker_rank_omtdbt_day
group by year, participant_code;

-- INSERT THE OMT DATA
insert into dibots_v2.broker_rank_omtdbt_year (year, trading_day_count, external_id, participant_code, participant_name, 
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
select year, trading_day_count, external_id, participant_code, participant_name, 
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
from dibots_v2.broker_rank_year
where year < 2020

-- UPDATE ALGOs columns
update dibots_v2.broker_rank_omtdbt_year a
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
from dibots_v2.broker_rank_year b
where a.year = b.year and a.participant_code = b.participant_code;

-- participant_name
update dibots_v2.broker_rank_omtdbt_year a
set 
participant_name = b.participant_name,
external_id = b.external_id
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false;

-- trading_day_count
update dibots_v2.broker_rank_omtdbt_year a
set
trading_day_count = tmp.day_count
from 
(select year, participant_code, count(*) as day_count from dibots_v2.broker_rank_omtdbt_day
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

--===============
-- TOTALS TABLES
--===============

--drop table dibots_v2.broker_rank_omtdbt_year_totals;
create table dibots_v2.broker_rank_omtdbt_year_totals (
year int,
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

select * from dibots_v2.broker_rank_omtdbt_year_totals;

insert into dibots_v2.broker_rank_omtdbt_year_totals (year, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select year, sum(total_vol), sum(total_val), 
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
from dibots_v2.broker_rank_omtdbt_year
group by year;


-- INSERT OMT into the table
insert into dibots_v2.broker_rank_omtdbt_year_totals (year, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select year, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, local_trade_pct, foreign_trade_volume, foreign_trade_value, foreign_trade_pct, 
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
from dibots_v2.broker_rank_year_totals
where year < 2020

update dibots_v2.broker_rank_omtdbt_year_totals a
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
from dibots_v2.broker_rank_year_totals b
where a.year = b.year and a.algo_count is null;

--UPDATE PCT COLUMNS
update dibots_v2.broker_rank_omtdbt_year a
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
from dibots_v2.broker_rank_omtdbt_year_totals b
where a.year = b.year;

select year, sum(total_pct), sum(local_pct), sum(foreign_pct), sum(nominees_pct), sum(local_nominees_pct), sum(foreign_nominees_pct), sum(inst_pct), sum(local_inst_pct), sum(foreign_inst_pct), 
sum(retail_pct), sum(local_retail_pct), sum(foreign_retail_pct), sum(prop_pct), sum(ivt_pct), sum(pdt_pct)
from dibots_v2.broker_rank_omtdbt_year
group by year;

--================================
-- Updating the rank columns
--================================

-- rank_total
update dibots_v2.broker_rank_omtdbt_year a
set
rank_total = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where total_val <> 0
group by year, participant_code, total_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_val <> 0
group by year, participant_code, local_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_val <> 0
group by year, participant_code, foreign_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where inst_val <> 0
group by year, participant_code, inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_inst_val <> 0
group by year, participant_code, local_inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_inst_val <> 0
group by year, participant_code, foreign_inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where retail_val <> 0
group by year, participant_code, retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_retail_val <> 0
group by year, participant_code, local_retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_retail_val <> 0
group by year, participant_code, foreign_retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where nominees_val <> 0
group by year, participant_code, nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_nominees_val <> 0
group by year, participant_code, local_nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_nominees_val <> 0
group by year, participant_code, foreign_nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_year a
set
rank_prop = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where prop_val <> 0
group by year, participant_code, prop_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_year a
set
rank_ivt = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where ivt_val <> 0
group by year, participant_code, ivt_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_year a
set
rank_pdt = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where pdt_val <> 0
group by year, participant_code, pdt_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

--========================
-- INCREMENTAL UPDATE
--========================

-- need to delete the last records
select max(year) from dibots_v2.broker_rank_omtdbt_year;

delete from dibots_v2.broker_rank_omtdbt_year where year = (select max(year) from dibots_v2.broker_rank_omtdbt_year);

insert into dibots_v2.broker_rank_omtdbt_year(year, participant_code, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, prop_vol, prop_val, ivt_vol, ivt_val, pdt_vol, pdt_val)
select year, participant_code, sum(total_vol), sum(total_val), sum(local_vol), sum(local_val), sum(foreign_vol), sum(foreign_val),
sum(inst_vol), sum(inst_val), sum(local_inst_vol), sum(local_inst_val), sum(foreign_inst_vol), sum(foreign_inst_val), sum(retail_vol), sum(retail_val), sum(local_retail_vol), sum(local_retail_val), 
sum(foreign_retail_vol), sum(foreign_retail_val), sum(nominees_vol), sum(nominees_val), sum(local_nominees_vol), sum(local_nominees_val), sum(foreign_nominees_vol), sum(foreign_nominees_val),
sum(prop_vol), sum(prop_val), sum(ivt_vol), sum(ivt_val), sum(pdt_vol), sum(pdt_val)
from dibots_v2.broker_rank_omtdbt_day
where year > (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code;

-- participant_name
update dibots_v2.broker_rank_omtdbt_year a
set 
participant_name = b.participant_name,
external_id = b.external_id
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false and a.participant_name is null;

-- trading_day_count
update dibots_v2.broker_rank_omtdbt_year a
set
trading_day_count = tmp.day_count
from 
(select year, participant_code, count(*) as day_count from dibots_v2.broker_rank_omtdbt_day
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code and a.trading_day_count is null;

-- Get the ALGOs from broker_rank_year table
update dibots_v2.broker_rank_omtdbt_year a
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
from dibots_v2.broker_rank_year b
where a.year = b.year and a.participant_code = b.participant_code and a.year >= ?;

-- TOTALS

-- DELETE LATEST FIRST
select max(year) from dibots_v2.broker_rank_omtdbt_year_totals;

delete from dibots_v2.broker_rank_omtdbt_year_totals where year = (select max(year) from dibots_v2.broker_rank_omtdbt_year_totals);

insert into dibots_v2.broker_rank_omtdbt_year_totals (year, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct)
select year, sum(total_vol), sum(total_val), 
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
from dibots_v2.broker_rank_omtdbt_year
where year > (select max(year) from dibots_v2.broker_rank_omtdbt_year_totals)
group by year;

update dibots_v2.broker_rank_omtdbt_year_totals a
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
from dibots_v2.broker_rank_year_totals b
where a.year = b.year and a.algo_count is null;

--UPDATE PCT COLUMNS
update dibots_v2.broker_rank_omtdbt_year a
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
from dibots_v2.broker_rank_omtdbt_year_totals b
where a.year = b.year and a.year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year);

-- RANKINGS

-- rank_total
update dibots_v2.broker_rank_omtdbt_year a
set
rank_total = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where total_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, total_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, local_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, foreign_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where inst_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_inst_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, local_inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_inst = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_inst_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, foreign_inst_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where retail_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_retail_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, local_retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_retail = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_retail_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, foreign_retail_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where nominees_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_local_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where local_nominees_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, local_nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_year a
set
rank_foreign_nominees = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where foreign_nominees_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, foreign_nominees_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_year a
set
rank_prop = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where prop_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, prop_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_year a
set
rank_ivt = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where ivt_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, ivt_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_year a
set
rank_pdt = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
where pdt_val <> 0 and year >= (select max(year) from dibots_v2.broker_rank_omtdbt_year)
group by year, participant_code, pdt_val) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;


select * from dibots_v2.broker_rank_omtdbt_year where year = (select max(year) from dibots_v2.broker_rank_omtdbt_year)