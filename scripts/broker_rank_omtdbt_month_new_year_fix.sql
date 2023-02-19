-- BROKER_RANK_OMTDBT_MONTH manual intervention on new year

select * from dibots_v2.broker_rank_omtdbt_month where year = 2022 and month = 1;

insert into dibots_v2.broker_rank_omtdbt_month(year, month, participant_code, total_vol, total_val, local_vol, local_val, foreign_vol, foreign_val,
inst_vol, inst_val, local_inst_vol, local_inst_val, foreign_inst_vol, foreign_inst_val, retail_vol, retail_val, local_retail_vol, local_retail_val, foreign_retail_vol, foreign_retail_val, 
nominees_vol, nominees_val, local_nominees_vol, local_nominees_val, foreign_nominees_vol, foreign_nominees_val, prop_vol, prop_val, ivt_vol, ivt_val, pdt_vol, pdt_val,
buy_vol, buy_val, sell_vol, sell_val)
select year, month, participant_code, sum(total_vol), sum(total_val), sum(local_vol), sum(local_val), sum(foreign_vol), sum(foreign_val),
sum(inst_vol), sum(inst_val), sum(local_inst_vol), sum(local_inst_val), sum(foreign_inst_vol), sum(foreign_inst_val), sum(retail_vol), sum(retail_val), sum(local_retail_vol), sum(local_retail_val), 
sum(foreign_retail_vol), sum(foreign_retail_val), sum(nominees_vol), sum(nominees_val), sum(local_nominees_vol), sum(local_nominees_val), sum(foreign_nominees_vol), sum(foreign_nominees_val),
sum(prop_vol), sum(prop_val), sum(ivt_vol), sum(ivt_val), sum(pdt_vol), sum(pdt_val), sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.broker_rank_omtdbt_day
where year >= 2022 and month >= 1
group by year, month, participant_code;

--year_month
update dibots_v2.broker_rank_omtdbt_month
set
year_month = concat(year, '-', case when length(cast(month as varchar)) = 1 THEN concat('0', cast(month as varchar)) ELSE cast(month as varchar) end)
where year_month is null;

-- participant_name
update dibots_v2.broker_rank_omtdbt_month a
set 
participant_name = b.participant_name,
external_id = b.external_id
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false and a.participant_name is null;

-- trading_day_count
update dibots_v2.broker_rank_omtdbt_month a
set
trading_day_count = tmp.day_count
from 
(select year, month, participant_code, count(*) as day_count from dibots_v2.broker_rank_omtdbt_day
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code and a.trading_day_count is null;

-- Get the ALGOs from broker_rank_month table
update dibots_v2.broker_rank_omtdbt_month a
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
from dibots_v2.broker_rank_month b
where a.year_month = b.year_month and a.participant_code = b.participant_code and a.year >= 2022 and a.month >= 1;

select * from dibots_v2.broker_rank_omtdbt_month_totals order by year_month desc;

insert into dibots_v2.broker_rank_omtdbt_month_totals (year, month, year_month, total_vol, total_val, local_vol, local_val, local_pct, foreign_vol, foreign_val, foreign_pct, inst_vol, inst_val, inst_pct,
local_inst_vol, local_inst_val, local_inst_pct, foreign_inst_vol, foreign_inst_val, foreign_inst_pct, retail_vol, retail_val, retail_pct, local_retail_vol, local_retail_val, local_retail_pct,
foreign_retail_vol, foreign_retail_val, foreign_retail_pct, nominees_vol, nominees_val, nominees_pct, local_nominees_vol, local_nominees_val, local_nominees_pct, foreign_nominees_vol,
foreign_nominees_val, foreign_nominees_pct, prop_vol, prop_val, prop_pct, ivt_vol, ivt_val, ivt_pct, pdt_vol, pdt_val, pdt_pct, buy_vol, buy_val, sell_vol, sell_val)
select year, month, year_month, sum(total_vol), sum(total_val), 
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
sum(pdt_vol), sum(pdt_val), sum(pdt_val) / sum(total_val) * 100,
sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.broker_rank_omtdbt_month
where year >= 2022 and month >= 1
group by year, month, year_month;

-- UPDATE TRD ORIGIN COLS
update dibots_v2.broker_rank_omtdbt_month_totals a
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
from dibots_v2.broker_rank_month_totals b
where a.year = b.year and a.month = b.month and a.algo_count is null;


--UPDATE PCT COLUMNS
update dibots_v2.broker_rank_omtdbt_month a
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
pdt_pct = a.pdt_val / b.pdt_val * 100,
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_month_totals b
where a.year = b.year and a.month = b.month and a.year >= 2022 and a.month >= 1;

-- rank_total
update dibots_v2.broker_rank_omtdbt_month a
set
rank_total = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by total_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where total_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, total_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_omtdbt_month a
set
rank_local = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by local_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where local_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, local_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_omtdbt_month a
set
rank_foreign = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by foreign_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where foreign_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, foreign_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_inst
update dibots_v2.broker_rank_omtdbt_month a
set
rank_inst = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where inst_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, inst_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_local_inst
update dibots_v2.broker_rank_omtdbt_month a
set
rank_local_inst = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by local_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where local_inst_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, local_inst_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_foreign_inst
update dibots_v2.broker_rank_omtdbt_month a
set
rank_foreign_inst = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by foreign_inst_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where foreign_inst_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, foreign_inst_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_retail
update dibots_v2.broker_rank_omtdbt_month a
set
rank_retail = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where retail_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, retail_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_local_retail
update dibots_v2.broker_rank_omtdbt_month a
set
rank_local_retail = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by local_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where local_retail_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, local_retail_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_foreign_retail
update dibots_v2.broker_rank_omtdbt_month a
set
rank_foreign_retail = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by foreign_retail_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where foreign_retail_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, foreign_retail_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_nominees
update dibots_v2.broker_rank_omtdbt_month a
set
rank_nominees = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where nominees_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, nominees_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_local_nominees
update dibots_v2.broker_rank_omtdbt_month a
set
rank_local_nominees = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by local_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where local_nominees_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, local_nominees_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_foreign_nominees
update dibots_v2.broker_rank_omtdbt_month a
set
rank_foreign_nominees = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by foreign_nominees_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where foreign_nominees_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, foreign_nominees_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_prop
update dibots_v2.broker_rank_omtdbt_month a
set
rank_prop = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by prop_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where prop_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, prop_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_omtdbt_month a
set
rank_ivt = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by ivt_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where ivt_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, ivt_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_omtdbt_month a
set
rank_pdt = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by pdt_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where pdt_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code, pdt_val) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_buy_vol
update dibots_v2.broker_rank_omtdbt_month a
set
rank_buy_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_month
where buy_vol <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_buy_val
update dibots_v2.broker_rank_omtdbt_month a
set
rank_buy_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where buy_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_sell_vol
update dibots_v2.broker_rank_omtdbt_month a
set
rank_sell_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_month
where sell_vol <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

-- rank_sell_val
update dibots_v2.broker_rank_omtdbt_month a
set
rank_sell_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
where sell_val <> 0 and year >= 2022 and month >= 1
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

