--====================================================
-- The PERIODICAL TO-DATE broker rank OMT DBT table
--====================================================

--========================
-- BROKER_RANK_OMTDBT_WTD
--========================

--drop table if exists dibots_v2.broker_rank_omtdbt_wtd;
create table dibots_v2.broker_rank_omtdbt_wtd (
trading_date date,
week_count varchar(10),
external_id bigint,
participant_code int,
participant_name varchar(255),
day_count int,
total_vol bigint,
total_val numeric(25,2),
total_pct numeric(10,2),
rank_total int,
local_vol bigint,
local_val numeric(25,2),
local_pct numeric(10,2),
rank_local int,
foreign_vol bigint,
foreign_val numeric(25,2),
foreign_pct numeric(10,2),
rank_foreign int,
inst_vol bigint,
inst_val numeric(25,2),
inst_pct numeric(10,2),
rank_inst int,
local_inst_vol bigint,
local_inst_val numeric(25,2),
local_inst_pct numeric(10,2),
rank_local_inst int,
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
foreign_inst_pct numeric(10,2),
rank_foreign_inst int,
retail_vol bigint,
retail_val numeric(25,2),
retail_pct numeric(10,2),
rank_retail int,
local_retail_vol bigint,
local_retail_val numeric(25,2),
local_retail_pct numeric(10,2),
rank_local_retail int,
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
foreign_retail_pct numeric(10,2),
rank_foreign_retail int,
nominees_vol bigint,
nominees_val numeric(25,2),
nominees_pct numeric(10,2),
rank_nominees int,
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
local_nominees_pct numeric(10,2),
rank_local_nominees int,
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
foreign_nominees_pct numeric(10,2),
rank_foreign_nominees int,
prop_vol bigint,
prop_val numeric(25,2),
prop_pct numeric(10,2),
rank_prop int,
ivt_vol bigint,
ivt_val numeric(25,2),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_vol bigint,
pdt_val numeric(25,2),
pdt_pct numeric(10,2),
rank_pdt int,
market_algo_count numeric(25,2),
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
ot_ratio numeric(10,2),
buy_vol bigint,
buy_vol_pct numeric(10,2),
rank_buy_vol int,
buy_val numeric(32,5),
buy_val_pct numeric(10,2),
rank_buy_val int,
sell_vol bigint,
sell_vol_pct numeric(10,2),
rank_sell_vol,
sell_val numeric(32,5)
sell_val_pct numeric(10,2),
rank_sell_val int
);

alter table dibots_v2.broker_rank_omtdbt_wtd add constraint broker_od_wtd_pkey primary key (trading_date, participant_code);
create index broker_od_wtd_ext_id_idx on dibots_v2.broker_rank_omtdbt_wtd (external_id);

-- INSERT the first day data for PYTHON script to run
insert into dibots_v2.broker_rank_omtdbt_wtd (trading_date, week_count, external_id, participant_code, participant_name, day_count, total_vol, total_val, total_pct, rank_total, 
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign, 
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst, 
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail, foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail, 
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees, 
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees, 
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt)
select trading_date, week_count, external_id, participant_code, participant_name, 1, total_vol, total_val, total_pct, rank_total,
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign,
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees,
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees,
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst,
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail,
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt
from dibots_v2.broker_rank_omtdbt_day
where trading_date = '2020-01-02'

-- INSERT THE OMT data
insert into dibots_v2.broker_rank_omtdbt_wtd (trading_date, week_count, external_id, participant_code, participant_name, day_count, 
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
market_algo_count, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet,
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok, 
ord_count, trd_count, ot_ratio, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val)
select trading_date, week_count, external_id, participant_code, participant_name, wtd_day_count, 
wtd_total_vol, wtd_total_val, wtd_total_pct, wtd_total_rank, 
wtd_local_vol, wtd_local_val, wtd_local_pct, wtd_local_rank, 
wtd_foreign_vol, wtd_foreign_val, wtd_foreign_pct, wtd_foreign_rank, 
wtd_inst_total_vol, wtd_inst_total_val, wtd_inst_total_pct, wtd_inst_total_rank, 
wtd_inst_local_vol, wtd_inst_local_val, wtd_inst_local_pct, wtd_inst_local_rank, 
wtd_inst_foreign_vol, wtd_inst_foreign_val, wtd_inst_foreign_pct, wtd_inst_foreign_rank, 
wtd_retail_total_vol, wtd_retail_total_val, wtd_retail_total_pct, wtd_retail_total_rank, 
wtd_retail_local_vol, wtd_retail_local_val, wtd_retail_local_pct, wtd_retail_local_rank, 
wtd_retail_foreign_vol, wtd_retail_foreign_val, wtd_retail_foreign_pct, wtd_retail_foreign_rank, 
wtd_nominee_total_vol, wtd_nominee_total_val, wtd_nominee_total_pct, wtd_nominee_total_rank, 
wtd_nominee_local_vol, wtd_nominee_local_val, wtd_nominee_local_pct, wtd_nominee_local_rank, 
wtd_nominee_foreign_vol, wtd_nominee_foreign_val, wtd_nominee_foreign_pct, wtd_nominee_foreign_rank, 
wtd_proprietary_vol, wtd_proprietary_val, wtd_proprietary_pct, wtd_proprietary_rank, 
wtd_ivt_vol, wtd_ivt_val, wtd_ivt_pct, wtd_ivt_rank, 
wtd_pdt_vol, wtd_pdt_val, wtd_pdt_pct, wtd_pdt_rank,
wtd_market_algo_cnt, 
wtd_algo_cnt, wtd_algo_pct, wtd_algo_rank, 
wtd_inet_cnt, wtd_inet_pct, wtd_inet_rank, 
wtd_dma_cnt, wtd_dma_pct, wtd_dma_rank, 
wtd_brok_cnt, wtd_brok_pct, wtd_brok_rank, 
wtd_ord_cnt, wtd_trd_cnt, wtd_ot_ratio,
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val
from dibots_v2.broker_rank_wtd
where trading_date < '2020-01-01';


-- UPDATE ALGOs columns
update dibots_v2.broker_rank_omtdbt_wtd a
set
market_algo_count = b.wtd_market_algo_cnt,
algo_count = b.wtd_algo_cnt,
algo_pct = b.wtd_algo_pct,
rank_algo = b.wtd_algo_rank,
inet_count = b.wtd_inet_cnt,
inet_pct = b.wtd_inet_pct,
rank_inet = b.wtd_inet_rank,
dma_count = b.wtd_dma_cnt,
dma_pct = b.wtd_dma_pct,
rank_dma = b.wtd_dma_rank,
brok_count = b.wtd_brok_cnt,
brok_pct = b.wtd_brok_pct,
rank_brok = b.wtd_brok_rank,
ord_count = b.wtd_ord_cnt,
trd_count = b.wtd_trd_cnt,
ot_ratio = b.wtd_ot_ratio
from dibots_v2.broker_rank_wtd b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_wtd;

-- INCREMENTAL run with python script
insert into dibots_v2.broker_rank_omtdbt_wtd (trading_date, week_count, external_id, participant_code, participant_name)
select trading_date, week_count, external_id, participant_code, participant_name from dibots_v2.broker_rank_omtdbt_day
where trading_date > %s;

select distinct trading_date from dibots_v2.broker_rank_omtdbt_wtd where total_vol is null
order by trading_date

-- get the group by values
select week_count, participant_code, count(*) as count, sum(total_vol) as total_vol, sum(total_val) as total_val, sum(local_vol) as local_vol, 
sum(local_val) as local_val, sum(foreign_vol) as foreign_vol, sum(foreign_val) as foreign_val, sum(inst_vol) as inst_vol, sum(inst_val) as inst_val, sum(local_inst_vol) as local_inst_vol, sum(local_inst_val) as local_inst_val,
sum(foreign_inst_vol) as foreign_inst_vol, sum(foreign_inst_val) as foreign_inst_val, sum(retail_vol) as retail_vol, sum(retail_val) as retail_val, sum(local_retail_vol) as local_retail_vol, 
sum(local_retail_val) as local_retail_val, sum(foreign_retail_vol) as foreign_retail_vol, sum(foreign_retail_val) as foreign_retail_val, 
sum(nominees_vol) as nominees_vol, sum(nominees_val) as nominees_val, sum(local_nominees_vol) as local_nominees_vol, 
sum(local_nominees_val) as local_nominees_val, sum(foreign_nominees_vol) as foreign_nominees_vol, sum(foreign_nominees_val) as foreign_nominees_val, 
sum(prop_vol) as prop_vol, sum(prop_val) as prop_val, sum(ivt_vol) as ivt_vol, sum(ivt_val) as ivt_val, sum(pdt_vol) as pdt_vol, sum(pdt_val) as pdt_val,
sum(algo_count) as algo_count, sum(inet_count) as inet_count, sum(dma_count) as dma_count, sum(brok_count) as brok_count, sum(ord_count) as ord_count, sum(trd_count) as trd_count
from dibots_v2.broker_rank_omtdbt_day where trading_date <= '2020-01-20' and week_count = '2020-04'
group by week_count, participant_code

-- UPDATE the vol val columns based on the result above
update dibots_v2.broker_rank_omtdbt_wtd
set
total_vol = %s,
total_val = %s,
local_vol = %s,
local_val = %s,
foreign_vol = %s,
foreign_val = %s,
inst_vol = %s,
inst_val = %s,
local_inst_vol = %s,
local_inst_val = %s,
foreign_inst_vol = %s,
foreign_inst_val = %s,
retail_vol = %s,
retail_val = %s,
local_retail_vol = %s,
local_retail_val = %s,
foreign_retail_vol = %s,
foreign_retail_val = %s,
nominees_vol = %s,
nominees_val = %s,
local_nominees_vol = %s,
local_nominees_val = %s,
foreign_nominees_vol = %s,
foreign_nominees_val = %s,
prop_vol = %s,
prop_val = %s,
ivt_vol = %s,
ivt_val = %s,
pdt_vol = %s,
pdt_val = %s,
algo_count = %s,
inet_count = %s,
dma_count = %s,
brok_count = %s,
ord_count = %s,
trd_count = %s
where trading_date = %s and week_count = %s and participant_code = %s

-- get the totals
select week_count, sum(total_vol) as total_vol, sum(total_val) as total_val, sum(local_vol) as local_vol, 
sum(local_val) as local_val, sum(foreign_vol) as foreign_vol, sum(foreign_val) as foreign_val, sum(inst_vol) as inst_vol, sum(inst_val) as inst_val, sum(local_inst_vol) as local_inst_vol, sum(local_inst_val) as local_inst_val,
sum(foreign_inst_vol) as foreign_inst_vol, sum(foreign_inst_val) as foreign_inst_val, sum(retail_vol) as retail_vol, sum(retail_val) as retail_val, sum(local_retail_vol) as local_retail_vol, 
sum(local_retail_val) as local_retail_val, sum(foreign_retail_vol) as foreign_retail_vol, sum(foreign_retail_val) as foreign_retail_val, 
sum(nominees_vol) as nominees_vol, sum(nominees_val) as nominees_val, sum(local_nominees_vol) as local_nominees_vol, 
sum(local_nominees_val) as local_nominees_val, sum(foreign_nominees_vol) as foreign_nominees_vol, sum(foreign_nominees_val) as foreign_nominees_val, 
sum(prop_vol) as prop_vol, sum(prop_val) as prop_val, sum(ivt_vol) as ivt_vol, sum(ivt_val) as ivt_val, sum(pdt_vol) as pdt_vol, sum(pdt_val) as pdt_val,
sum(algo_count) as algo_count, sum(inet_count) as inet_count, sum(dma_count) as dma_count, sum(brok_count) as brok_count
from dibots_v2.broker_rank_omtdbt_day where trading_date <= '2020-01-20'
group by week_count

-- UPDATE the pct with the total
update dibots_v2.broker_rank_omtdbt_wtd
set
total_pct = total_val / %s * 100,
local_pct = local_val / %s * 100,
foreign_pct = foreign_val / %s * 100,
inst_pct = inst_val / %s * 100,
local_inst_pct = local_inst_val / %s * 100,
foreign_inst_pct = foreign_inst_val / %s * 100,
retail_pct = retail_val / %s * 100,
local_retail_pct = local_retail_val / %s * 100,
foreign_retail_pct = foreign_retail_val / %s * 100,
nominees_pct = nominees_val / %s * 100,
local_nominees_pct = local_nominees_val / %s * 100,
foreign_nominees_pct = foreign_nominees_val / %s * 100,
prop_pct = prop_val / %s * 100,
ivt_pct = ivt_val / %s * 100,
pdt_pct = pdt_val / %s * 100,
algo_pct = algo_count / %s * 100,
inet_pct = inet_count / %s * 100,
dma_pct = dma_count / %s * 100,
brok_pct = brok_count / %s * 100
where trading_date = %s and week_count = %s and participant_code = %s;

-- RANKINGS
-- rank_total
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_total = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where trading_date = %s
group by trading_date, participant_code, total_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_local = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where local_val <> 0 and trading_date = %s
group by trading_date, participant_code, local_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_foreign = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where foreign_val <> 0 and trading_date = %s
group by trading_date, participant_code, foreign_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where inst_val <> 0 and trading_date = %s
group by trading_date, participant_code, inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_local_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where local_inst_val <> 0 and trading_date = %s
group by trading_date, participant_code, local_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_foreign_inst = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where foreign_inst_val <> 0 and trading_date = %s
group by trading_date, participant_code, foreign_inst_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where retail_val <> 0 and trading_date = %s
group by trading_date, participant_code, retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_local_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where local_retail_val <> 0 and trading_date = %s
group by trading_date, participant_code, local_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_foreign_retail = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where foreign_retail_val <> 0 and trading_date = %s
group by trading_date, participant_code, foreign_retail_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where nominees_val <> 0 and trading_date = %s
group by trading_date, participant_code, nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_local_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where local_nominees_val <> 0 and trading_date = %s
group by trading_date, participant_code, local_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_foreign_nominees = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where foreign_nominees_val <> 0 and trading_date = %s
group by trading_date, participant_code, foreign_nominees_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_prop = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where prop_val <> 0 and trading_date = %s
group by trading_date, participant_code, prop_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_ivt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where ivt_val <> 0 and trading_date = %s
group by trading_date, participant_code, ivt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_pdt = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where pdt_val <> 0 and trading_date = %s
group by trading_date, participant_code, pdt_val) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_algo
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_algo = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by algo_count desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where algo_count is not null and algo_count <> 0 and trading_date = %s
group by trading_date, participant_code, algo_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_inet
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_inet = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by inet_count desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where inet_count is not null and inet_count <> 0 and trading_date = %s
group by trading_date, participant_code, inet_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_dma
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_dma = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by dma_count desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where dma_count is not null and dma_count <> 0 and trading_date = %s
group by trading_date, participant_code, dma_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- rank_brok
update dibots_v2.broker_rank_omtdbt_wtd a
set
rank_brok = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by brok_count desc) rank
from dibots_v2.broker_rank_omtdbt_wtd
where brok_count is not null and brok_count <> 0 and trading_date = %s
group by trading_date, participant_code, brok_count) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

-- ot_ratio
update dibots_v2.broker_rank_omtdbt_wtd a
set
ot_ratio = cast(ord_count as numeric) / cast(trd_count as numeric)
where ord_count is not null and trd_count is not null and ot_ratio is null;

--============================
-- BROKER_RANK_OMTDBT_MTD
--===========================

--drop table dibots_v2.broker_rank_omtdbt_mtd;
create table dibots_v2.broker_rank_omtdbt_mtd (
trading_date date,
year int,
month int,
external_id bigint,
participant_code int,
participant_name varchar(255),
day_count int,
total_vol bigint,
total_val numeric(25,2),
total_pct numeric(10,2),
rank_total int,
local_vol bigint,
local_val numeric(25,2),
local_pct numeric(10,2),
rank_local int,
foreign_vol bigint,
foreign_val numeric(25,2),
foreign_pct numeric(10,2),
rank_foreign int,
inst_vol bigint,
inst_val numeric(25,2),
inst_pct numeric(10,2),
rank_inst int,
local_inst_vol bigint,
local_inst_val numeric(25,2),
local_inst_pct numeric(10,2),
rank_local_inst int,
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
foreign_inst_pct numeric(10,2),
rank_foreign_inst int,
retail_vol bigint,
retail_val numeric(25,2),
retail_pct numeric(10,2),
rank_retail int,
local_retail_vol bigint,
local_retail_val numeric(25,2),
local_retail_pct numeric(10,2),
rank_local_retail int,
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
foreign_retail_pct numeric(10,2),
rank_foreign_retail int,
nominees_vol bigint,
nominees_val numeric(25,2),
nominees_pct numeric(10,2),
rank_nominees int,
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
local_nominees_pct numeric(10,2),
rank_local_nominees int,
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
foreign_nominees_pct numeric(10,2),
rank_foreign_nominees int,
prop_vol bigint,
prop_val numeric(25,2),
prop_pct numeric(10,2),
rank_prop int,
ivt_vol bigint,
ivt_val numeric(25,2),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_vol bigint,
pdt_val numeric(25,2),
pdt_pct numeric(10,2),
rank_pdt int,
market_algo_count numeric(25,2),
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
ot_ratio numeric(10,2),
buy_vol bigint,
buy_vol_pct numeric(10,2),
rank_buy_vol int,
buy_val numeric(32,5),
buy_val_pct numeric(10,2),
rank_buy_val int,
sell_vol bigint,
sell_vol_pct numeric(10,2),
rank_sell_vol,
sell_val numeric(32,5)
sell_val_pct numeric(10,2),
rank_sell_val int
);

alter table dibots_v2.broker_rank_omtdbt_mtd add constraint broker_od_mtd_pkey primary key (trading_date, participant_code);
create index broker_od_mtd_ext_id_idx on dibots_v2.broker_rank_omtdbt_mtd (external_id);

-- INSERT the first day data for PYTHON script to run
insert into dibots_v2.broker_rank_omtdbt_mtd (trading_date, year, month, external_id, participant_code, participant_name, day_count, total_vol, total_val, total_pct, rank_total, 
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign, 
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst, 
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail, foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail, 
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees, 
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees, 
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt)
select trading_date, year, month, external_id, participant_code, participant_name, 1, total_vol, total_val, total_pct, rank_total,
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign,
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees,
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees,
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst,
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail,
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt
from dibots_v2.broker_rank_omtdbt_day
where trading_date = '2020-01-02'

-- INSERT OMT data
insert into dibots_v2.broker_rank_omtdbt_mtd (trading_date, year, month, external_id, participant_code, participant_name, day_count, 
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
market_algo_count, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet,
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok, 
ord_count, trd_count, ot_ratio, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val)
select trading_date, year, month, external_id, participant_code, participant_name, mtd_day_count, 
mtd_total_vol, mtd_total_val, mtd_total_pct, mtd_total_rank, 
mtd_local_vol, mtd_local_val, mtd_local_pct, mtd_local_rank, 
mtd_foreign_vol, mtd_foreign_val, mtd_foreign_pct, mtd_foreign_rank, 
mtd_inst_total_vol, mtd_inst_total_val, mtd_inst_total_pct, mtd_inst_total_rank, 
mtd_inst_local_vol, mtd_inst_local_val, mtd_inst_local_pct, mtd_inst_local_rank, 
mtd_inst_foreign_vol, mtd_inst_foreign_val, mtd_inst_foreign_pct, mtd_inst_foreign_rank, 
mtd_retail_total_vol, mtd_retail_total_val, mtd_retail_total_pct, mtd_retail_total_rank, 
mtd_retail_local_vol, mtd_retail_local_val, mtd_retail_local_pct, mtd_retail_local_rank, 
mtd_retail_foreign_vol, mtd_retail_foreign_val, mtd_retail_foreign_pct, mtd_retail_foreign_rank, 
mtd_nominee_total_vol, mtd_nominee_total_val, mtd_nominee_total_pct, mtd_nominee_total_rank, 
mtd_nominee_local_vol, mtd_nominee_local_val, mtd_nominee_local_pct, mtd_nominee_local_rank, 
mtd_nominee_foreign_vol, mtd_nominee_foreign_val, mtd_nominee_foreign_pct, mtd_nominee_foreign_rank, 
mtd_proprietary_vol, mtd_proprietary_val, mtd_proprietary_pct, mtd_proprietary_rank, 
mtd_ivt_vol, mtd_ivt_val, mtd_ivt_pct, mtd_ivt_rank, 
mtd_pdt_vol, mtd_pdt_val, mtd_pdt_pct, mtd_pdt_rank,
mtd_market_algo_cnt, 
mtd_algo_cnt, mtd_algo_pct, mtd_algo_rank, 
mtd_inet_cnt, mtd_inet_pct, mtd_inet_rank, 
mtd_dma_cnt, mtd_dma_pct, mtd_dma_rank, 
mtd_brok_cnt, mtd_brok_pct, mtd_brok_rank, 
mtd_ord_cnt, mtd_trd_cnt, mtd_ot_ratio,
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val
from dibots_v2.broker_rank_mtd
where trading_date < '2020-01-01';

-- UPDATE ALGOs columns
update dibots_v2.broker_rank_omtdbt_mtd a
set
market_algo_count = b.mtd_market_algo_cnt,
algo_count = b.mtd_algo_cnt,
algo_pct = b.mtd_algo_pct,
rank_algo = b.mtd_algo_rank,
inet_count = b.mtd_inet_cnt,
inet_pct = b.mtd_inet_pct,
rank_inet = b.mtd_inet_rank,
dma_count = b.mtd_dma_cnt,
dma_pct = b.mtd_dma_pct,
rank_dma = b.mtd_dma_rank,
brok_count = b.mtd_brok_cnt,
brok_pct = b.mtd_brok_pct,
rank_brok = b.mtd_brok_rank,
ord_count = b.mtd_ord_cnt,
trd_count = b.mtd_trd_cnt,
ot_ratio = b.mtd_ot_ratio
from dibots_v2.broker_rank_mtd b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_mtd;

--===========================
-- BROKER_RANK_OMTDBT_QTD
--===========================

--drop table dibots_v2.broker_rank_omtdbt_qtd;
create table dibots_v2.broker_rank_omtdbt_qtd (
trading_date date,
year int,
month int,
qtr int,
external_id bigint,
participant_code int,
participant_name varchar(255),
day_count int,
total_vol bigint,
total_val numeric(25,2),
total_pct numeric(10,2),
rank_total int,
local_vol bigint,
local_val numeric(25,2),
local_pct numeric(10,2),
rank_local int,
foreign_vol bigint,
foreign_val numeric(25,2),
foreign_pct numeric(10,2),
rank_foreign int,
inst_vol bigint,
inst_val numeric(25,2),
inst_pct numeric(10,2),
rank_inst int,
local_inst_vol bigint,
local_inst_val numeric(25,2),
local_inst_pct numeric(10,2),
rank_local_inst int,
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
foreign_inst_pct numeric(10,2),
rank_foreign_inst int,
retail_vol bigint,
retail_val numeric(25,2),
retail_pct numeric(10,2),
rank_retail int,
local_retail_vol bigint,
local_retail_val numeric(25,2),
local_retail_pct numeric(10,2),
rank_local_retail int,
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
foreign_retail_pct numeric(10,2),
rank_foreign_retail int,
nominees_vol bigint,
nominees_val numeric(25,2),
nominees_pct numeric(10,2),
rank_nominees int,
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
local_nominees_pct numeric(10,2),
rank_local_nominees int,
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
foreign_nominees_pct numeric(10,2),
rank_foreign_nominees int,
prop_vol bigint,
prop_val numeric(25,2),
prop_pct numeric(10,2),
rank_prop int,
ivt_vol bigint,
ivt_val numeric(25,2),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_vol bigint,
pdt_val numeric(25,2),
pdt_pct numeric(10,2),
rank_pdt int,
market_algo_count numeric(25,2),
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
ot_ratio numeric(10,2),
buy_vol bigint,
buy_vol_pct numeric(10,2),
rank_buy_vol int,
buy_val numeric(32,5),
buy_val_pct numeric(10,2),
rank_buy_val int,
sell_vol bigint,
sell_vol_pct numeric(10,2),
rank_sell_vol,
sell_val numeric(32,5)
sell_val_pct numeric(10,2),
rank_sell_val int
);

alter table dibots_v2.broker_rank_omtdbt_qtd add constraint broker_od_qtd_pkey primary key (trading_date, participant_code);
create index broker_od_qtd_ext_id_idx on dibots_v2.broker_rank_omtdbt_qtd (external_id);

-- INSERT the first day data for PYTHON script to run
insert into dibots_v2.broker_rank_omtdbt_qtd (trading_date, year, month, qtr, external_id, participant_code, participant_name, day_count, total_vol, total_val, total_pct, rank_total, 
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign, 
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst, 
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail, foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail, 
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees, 
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees, 
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt)
select trading_date, year, month, qtr, external_id, participant_code, participant_name, 1, total_vol, total_val, total_pct, rank_total,
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign,
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees,
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees,
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst,
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail,
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt
from dibots_v2.broker_rank_omtdbt_day
where trading_date = '2020-01-02'

-- INSERT OMT data
insert into dibots_v2.broker_rank_omtdbt_qtd (trading_date, year, month, qtr, external_id, participant_code, participant_name, day_count, 
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
market_algo_count, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet,
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok, 
ord_count, trd_count, ot_ratio, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val)
select trading_date, year, month, qtr, external_id, participant_code, participant_name, qtd_day_count, 
qtd_total_vol, qtd_total_val, qtd_total_pct, qtd_total_rank, 
qtd_local_vol, qtd_local_val, qtd_local_pct, qtd_local_rank, 
qtd_foreign_vol, qtd_foreign_val, qtd_foreign_pct, qtd_foreign_rank, 
qtd_inst_total_vol, qtd_inst_total_val, qtd_inst_total_pct, qtd_inst_total_rank, 
qtd_inst_local_vol, qtd_inst_local_val, qtd_inst_local_pct, qtd_inst_local_rank, 
qtd_inst_foreign_vol, qtd_inst_foreign_val, qtd_inst_foreign_pct, qtd_inst_foreign_rank, 
qtd_retail_total_vol, qtd_retail_total_val, qtd_retail_total_pct, qtd_retail_total_rank, 
qtd_retail_local_vol, qtd_retail_local_val, qtd_retail_local_pct, qtd_retail_local_rank, 
qtd_retail_foreign_vol, qtd_retail_foreign_val, qtd_retail_foreign_pct, qtd_retail_foreign_rank, 
qtd_nominee_total_vol, qtd_nominee_total_val, qtd_nominee_total_pct, qtd_nominee_total_rank, 
qtd_nominee_local_vol, qtd_nominee_local_val, qtd_nominee_local_pct, qtd_nominee_local_rank, 
qtd_nominee_foreign_vol, qtd_nominee_foreign_val, qtd_nominee_foreign_pct, qtd_nominee_foreign_rank, 
qtd_proprietary_vol, qtd_proprietary_val, qtd_proprietary_pct, qtd_proprietary_rank, 
qtd_ivt_vol, qtd_ivt_val, qtd_ivt_pct, qtd_ivt_rank, 
qtd_pdt_vol, qtd_pdt_val, qtd_pdt_pct, qtd_pdt_rank,
qtd_market_algo_cnt, 
qtd_algo_cnt, qtd_algo_pct, qtd_algo_rank, 
qtd_inet_cnt, qtd_inet_pct, qtd_inet_rank, 
qtd_dma_cnt, qtd_dma_pct, qtd_dma_rank, 
qtd_brok_cnt, qtd_brok_pct, qtd_brok_rank, 
qtd_ord_cnt, qtd_trd_cnt, qtd_ot_ratio,
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val
from dibots_v2.broker_rank_qtd
where trading_date < '2020-01-01';

-- UPDATE ALGOs columns
update dibots_v2.broker_rank_omtdbt_qtd a
set
market_algo_count = b.qtd_market_algo_cnt,
algo_count = b.qtd_algo_cnt,
algo_pct = b.qtd_algo_pct,
rank_algo = b.qtd_algo_rank,
inet_count = b.qtd_inet_cnt,
inet_pct = b.qtd_inet_pct,
rank_inet = b.qtd_inet_rank,
dma_count = b.qtd_dma_cnt,
dma_pct = b.qtd_dma_pct,
rank_dma = b.qtd_dma_rank,
brok_count = b.qtd_brok_cnt,
brok_pct = b.qtd_brok_pct,
rank_brok = b.qtd_brok_rank,
ord_count = b.qtd_ord_cnt,
trd_count = b.qtd_trd_cnt,
ot_ratio = b.qtd_ot_ratio
from dibots_v2.broker_rank_qtd b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_qtd;

--==========================
-- BROKER_RANK_OMTDBT_YTD
--==========================

--drop table dibots_v2.broker_rank_omtdbt_ytd;
create table dibots_v2.broker_rank_omtdbt_ytd (
trading_date date,
year int,
external_id bigint,
participant_code int,
participant_name varchar(255),
day_count int,
total_vol bigint,
total_val numeric(25,2),
total_pct numeric(10,2),
rank_total int,
local_vol bigint,
local_val numeric(25,2),
local_pct numeric(10,2),
rank_local int,
foreign_vol bigint,
foreign_val numeric(25,2),
foreign_pct numeric(10,2),
rank_foreign int,
inst_vol bigint,
inst_val numeric(25,2),
inst_pct numeric(10,2),
rank_inst int,
local_inst_vol bigint,
local_inst_val numeric(25,2),
local_inst_pct numeric(10,2),
rank_local_inst int,
foreign_inst_vol bigint,
foreign_inst_val numeric(25,2),
foreign_inst_pct numeric(10,2),
rank_foreign_inst int,
retail_vol bigint,
retail_val numeric(25,2),
retail_pct numeric(10,2),
rank_retail int,
local_retail_vol bigint,
local_retail_val numeric(25,2),
local_retail_pct numeric(10,2),
rank_local_retail int,
foreign_retail_vol bigint,
foreign_retail_val numeric(25,2),
foreign_retail_pct numeric(10,2),
rank_foreign_retail int,
nominees_vol bigint,
nominees_val numeric(25,2),
nominees_pct numeric(10,2),
rank_nominees int,
local_nominees_vol bigint,
local_nominees_val numeric(25,2),
local_nominees_pct numeric(10,2),
rank_local_nominees int,
foreign_nominees_vol bigint,
foreign_nominees_val numeric(25,2),
foreign_nominees_pct numeric(10,2),
rank_foreign_nominees int,
prop_vol bigint,
prop_val numeric(25,2),
prop_pct numeric(10,2),
rank_prop int,
ivt_vol bigint,
ivt_val numeric(25,2),
ivt_pct numeric(10,2),
rank_ivt int,
pdt_vol bigint,
pdt_val numeric(25,2),
pdt_pct numeric(10,2),
rank_pdt int,
market_algo_count numeric(25,2),
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
ot_ratio numeric(10,2),
buy_vol bigint,
buy_vol_pct numeric(10,2),
rank_buy_vol int,
buy_val numeric(32,5),
buy_val_pct numeric(10,2),
rank_buy_val int,
sell_vol bigint,
sell_vol_pct numeric(10,2),
rank_sell_vol,
sell_val numeric(32,5)
sell_val_pct numeric(10,2),
rank_sell_val int
);

alter table dibots_v2.broker_rank_omtdbt_ytd add constraint broker_od_ytd_pkey primary key (trading_date, participant_code);
create index broker_od_ytd_ext_id_idx on dibots_v2.broker_rank_omtdbt_ytd (external_id);

-- INSERT the first day data for PYTHON script to run
insert into dibots_v2.broker_rank_omtdbt_ytd (trading_date, year, external_id, participant_code, participant_name, day_count, total_vol, total_val, total_pct, rank_total, 
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign, 
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst, 
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail, foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail, 
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees, 
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees, 
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt)
select trading_date, year, external_id, participant_code, participant_name, 1, total_vol, total_val, total_pct, rank_total,
local_vol, local_val, local_pct, rank_local, foreign_vol, foreign_val, foreign_pct, rank_foreign,
nominees_vol, nominees_val, nominees_pct, rank_nominees, local_nominees_vol, local_nominees_val, local_nominees_pct, rank_local_nominees,
foreign_nominees_vol, foreign_nominees_val, foreign_nominees_pct, rank_foreign_nominees,
inst_vol, inst_val, inst_pct, rank_inst, local_inst_vol, local_inst_val, local_inst_pct, rank_local_inst, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, rank_foreign_inst,
retail_vol, retail_val, retail_pct, rank_retail, local_retail_vol, local_retail_val, local_retail_pct, rank_local_retail,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, rank_foreign_retail,
prop_vol, prop_val, prop_pct, rank_prop, ivt_vol, ivt_val, ivt_pct, rank_ivt, pdt_vol, pdt_val, pdt_pct, rank_pdt
from dibots_v2.broker_rank_omtdbt_day
where trading_date = '2020-01-02'

insert into dibots_v2.broker_rank_omtdbt_ytd (trading_date, year, external_id, participant_code, participant_name, day_count, 
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
market_algo_count, 
algo_count, algo_pct, rank_algo, 
inet_count, inet_pct, rank_inet,
dma_count, dma_pct, rank_dma, 
brok_count, brok_pct, rank_brok, 
ord_count, trd_count, ot_ratio, 
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val)
select trading_date, year, external_id, participant_code, participant_name, ytd_day_count, 
ytd_total_vol, ytd_total_val, ytd_total_pct, ytd_total_rank, 
ytd_local_vol, ytd_local_val, ytd_local_pct, ytd_local_rank, 
ytd_foreign_vol, ytd_foreign_val, ytd_foreign_pct, ytd_foreign_rank, 
ytd_inst_total_vol, ytd_inst_total_val, ytd_inst_total_pct, ytd_inst_total_rank, 
ytd_inst_local_vol, ytd_inst_local_val, ytd_inst_local_pct, ytd_inst_local_rank, 
ytd_inst_foreign_vol, ytd_inst_foreign_val, ytd_inst_foreign_pct, ytd_inst_foreign_rank, 
ytd_retail_total_vol, ytd_retail_total_val, ytd_retail_total_pct, ytd_retail_total_rank, 
ytd_retail_local_vol, ytd_retail_local_val, ytd_retail_local_pct, ytd_retail_local_rank, 
ytd_retail_foreign_vol, ytd_retail_foreign_val, ytd_retail_foreign_pct, ytd_retail_foreign_rank, 
ytd_nominee_total_vol, ytd_nominee_total_val, ytd_nominee_total_pct, ytd_nominee_total_rank, 
ytd_nominee_local_vol, ytd_nominee_local_val, ytd_nominee_local_pct, ytd_nominee_local_rank, 
ytd_nominee_foreign_vol, ytd_nominee_foreign_val, ytd_nominee_foreign_pct, ytd_nominee_foreign_rank, 
ytd_proprietary_vol, ytd_proprietary_val, ytd_proprietary_pct, ytd_proprietary_rank, 
ytd_ivt_vol, ytd_ivt_val, ytd_ivt_pct, ytd_ivt_rank, 
ytd_pdt_vol, ytd_pdt_val, ytd_pdt_pct, ytd_pdt_rank,
ytd_market_algo_cnt, 
ytd_algo_cnt, ytd_algo_pct, ytd_algo_rank, 
ytd_inet_cnt, ytd_inet_pct, ytd_inet_rank, 
ytd_dma_cnt, ytd_dma_pct, ytd_dma_rank, 
ytd_brok_cnt, ytd_brok_pct, ytd_brok_rank, 
ytd_ord_cnt, ytd_trd_cnt, ytd_ot_ratio,
buy_vol, buy_vol_pct, rank_buy_vol, 
buy_val, buy_val_pct, rank_buy_val, 
sell_vol, sell_vol_pct, rank_sell_vol, 
sell_val, sell_val_pct, rank_sell_val
from dibots_v2.broker_rank_ytd
where trading_date < '2020-01-01';

-- UPDATE ALGOs columns
update dibots_v2.broker_rank_omtdbt_ytd a
set
market_algo_count = b.ytd_market_algo_cnt,
algo_count = b.ytd_algo_cnt,
algo_pct = b.ytd_algo_pct,
rank_algo = b.ytd_algo_rank,
inet_count = b.ytd_inet_cnt,
inet_pct = b.ytd_inet_pct,
rank_inet = b.ytd_inet_rank,
dma_count = b.ytd_dma_cnt,
dma_pct = b.ytd_dma_pct,
rank_dma = b.ytd_dma_rank,
brok_count = b.ytd_brok_cnt,
brok_pct = b.ytd_brok_pct,
rank_brok = b.ytd_brok_rank,
ord_count = b.ytd_ord_cnt,
trd_count = b.ytd_trd_cnt,
ot_ratio = b.ytd_ot_ratio
from dibots_v2.broker_rank_ytd b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_ytd;
