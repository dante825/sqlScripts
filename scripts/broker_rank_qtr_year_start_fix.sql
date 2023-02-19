-- BROKER RANK QTR pentaho ETL only works in the same year. Thus, every new year, it need a manual intervention

select * from dibots_v2.broker_rank_qtr where year = 2022 and qtr = 1;

insert into dibots_v2.broker_rank_qtr (year, qtr, external_id, participant_code, 
total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, foreign_trade_volume, foreign_trade_value, nominee_total_trade_volume, nominee_total_trade_value, nominee_local_trade_volume, nominee_local_trade_value,
nominee_foreign_trade_volume, nominee_foreign_trade_value, inst_total_trade_volume, inst_total_trade_value, inst_local_trade_volume, inst_local_trade_value, inst_foreign_trade_volume, inst_foreign_trade_value, 
retail_total_trade_volume, retail_total_trade_value, retail_local_trade_volume, retail_local_trade_value, retail_foreign_trade_volume, retail_foreign_trade_value, proprietary_trade_volume, 
proprietary_trade_value, ivt_trade_volume, ivt_trade_value, pdt_trade_volume, pdt_trade_value, algo_count, inet_count, dma_count, brok_count, ord_count, trd_count, 
buy_vol, buy_val, sell_vol, sell_val)
select year, qtr, external_id,  participant_code, sum(total_trade_volume), sum(total_trade_value), sum(local_trade_volume), sum(local_trade_value), sum(foreign_trade_volume), sum(foreign_trade_value),
sum(nominee_total_trade_volume), sum(nominee_total_trade_value), sum(nominee_local_trade_volume), sum(nominee_local_trade_value), sum(nominee_foreign_trade_volume), sum(nominee_foreign_trade_value),
sum(inst_total_trade_volume), sum(inst_total_trade_value), sum(inst_local_trade_volume), sum(inst_local_trade_value), sum(inst_foreign_trade_volume), sum(inst_foreign_trade_value),
sum(retail_total_trade_volume), sum(retail_total_trade_value), sum(retail_local_trade_volume), sum(retail_local_trade_value), sum(retail_foreign_trade_volume), sum(retail_foreign_trade_value),
sum(proprietary_trade_volume), sum(proprietary_trade_value), sum(ivt_trade_volume), sum(ivt_trade_value), sum(pdt_trade_volume), sum(pdt_trade_value), sum(algo_count), sum(inet_count), sum(dma_count), sum(brok_count),
sum(ord_count), sum(trd_count), sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.broker_rank_day
where year >= 2022 and qtr >= 1
group by year, qtr, external_id, participant_code;

-- participant_name
update dibots_v2.broker_rank_qtr a
set
participant_name = b.participant_name
from dibots_v2.broker_profile b
where a.participant_code = b.participant_code and b.is_deleted = false and b.eff_end_date is null and a.participant_name is null;

-- year_qtr
update dibots_v2.broker_rank_qtr 
set
year_qtr = concat(year, '-', qtr)
where year_qtr is null;

-- trading_day_count
update dibots_v2.broker_rank_qtr a
set
trading_day_count = tmp.day_count
from
(select year, qtr, participant_code, count(*) as day_count from dibots_v2.broker_rank_day
where year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- market_cap
update dibots_v2.broker_rank_qtr a
set
market_cap = tmp.mart_cap / trading_day_count
from
(select year, qtr, participant_code, sum(market_cap) as mart_cap
from dibots_v2.broker_rank_day
where participant_code = 73 -- random cuz if sum all market_cap value would be wrong
and year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr;

-- ann_velocity
update dibots_v2.broker_rank_qtr
set
ann_velocity = (total_trade_value / 2) / market_cap * 248 * 100
where ann_velocity is null;

-- ot_ratio
update dibots_v2.broker_rank_qtr
set ot_ratio = cast(ord_count as numeric) / cast(trd_count as numeric)
where ot_ratio is null;


select * from dibots_v2.broker_rank_qtr_totals order by year_qtr desc

insert into dibots_v2.broker_rank_qtr_totals (year, qtr, year_qtr, total_trade_volume, total_trade_value, local_trade_volume, local_trade_value, local_trade_pct, foreign_trade_volume, foreign_trade_value, foreign_trade_pct,
nominee_total_trade_volume, nominee_total_trade_value, nominee_total_trade_pct, nominee_local_trade_volume, nominee_local_trade_value, nominee_local_trade_pct, nominee_foreign_trade_volume, nominee_foreign_trade_value,
nominee_foreign_trade_pct, inst_total_trade_volume, inst_total_trade_value, inst_total_trade_pct, inst_local_trade_volume, inst_local_trade_value, inst_local_trade_pct, inst_foreign_trade_volume, inst_foreign_trade_value,
inst_foreign_trade_pct, retail_total_trade_volume, retail_total_trade_value, retail_total_trade_pct, retail_local_trade_volume, retail_local_trade_value, retail_local_trade_pct, retail_foreign_trade_volume, 
retail_foreign_trade_value, retail_foreign_trade_pct, proprietary_trade_volume, proprietary_trade_value, proprietary_trade_pct, ivt_trade_volume, ivt_trade_value, ivt_trade_pct, pdt_trade_volume, pdt_trade_value,
pdt_trade_pct, algo_count, algo_pct, inet_count, inet_pct, dma_count, dma_pct, brok_count, brok_pct, ord_count, trd_count, buy_vol, buy_val, sell_vol, sell_val)
select year, qtr, year_qtr, sum(total_trade_volume), sum(total_trade_value), 
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
sum(ord_count), sum(trd_count), sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val)
from dibots_v2.broker_rank_qtr
where year >= 2022 and qtr >= 1
group by year, qtr, year_qtr;

update dibots_v2.broker_rank_qtr_totals
set
market_ot_ratio = cast(ord_count as numeric) / cast(trd_count as numeric)
where ord_count is not null and trd_count is not null and market_ot_ratio is null;

update dibots_v2.broker_rank_qtr a
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
brok_pct = a.brok_count / b.brok_count * 100,
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_qtr_totals b
where a.year = b.year and a.qtr = b.qtr and b.year >= 2022 and b.qtr >= 1;

-- rank_total
update dibots_v2.broker_rank_qtr a
set
rank_total = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by total_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where year >= 2022 and qtr >= 1
group by year, qtr, participant_code, total_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_local
update dibots_v2.broker_rank_qtr a
set
rank_local = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by local_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where year >= 2022 and qtr >= 1
group by year, qtr, participant_code, local_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_foreign
update dibots_v2.broker_rank_qtr a
set
rank_foreign = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by foreign_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where foreign_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, foreign_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_nominee_total
update dibots_v2.broker_rank_qtr a
set
rank_nominee_total = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by nominee_total_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where nominee_total_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, nominee_total_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_nominee_local
update dibots_v2.broker_rank_qtr a
set
rank_nominee_local = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by nominee_local_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where nominee_local_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, nominee_local_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_nominee_foreign
update dibots_v2.broker_rank_qtr a
set
rank_nominee_foreign = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by nominee_foreign_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where nominee_foreign_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, nominee_foreign_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_inst_total
update dibots_v2.broker_rank_qtr a
set
rank_inst_total = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by inst_total_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where inst_total_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, inst_total_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_inst_local
update dibots_v2.broker_rank_qtr a
set
rank_inst_local = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by inst_local_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where inst_local_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, inst_local_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_inst_foreign
update dibots_v2.broker_rank_qtr a
set
rank_inst_foreign = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by inst_foreign_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where inst_foreign_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, inst_foreign_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_retail_total
update dibots_v2.broker_rank_qtr a
set
rank_retail_total = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by retail_total_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where retail_total_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, retail_total_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_retail_local
update dibots_v2.broker_rank_qtr a
set
rank_retail_local = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by retail_local_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where retail_local_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, retail_local_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_retail_foreign
update dibots_v2.broker_rank_qtr a
set
rank_retail_foreign = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by retail_foreign_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where retail_foreign_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, retail_foreign_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_proprietary
update dibots_v2.broker_rank_qtr a
set
rank_proprietary = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by proprietary_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where proprietary_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, proprietary_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_ivt
update dibots_v2.broker_rank_qtr a
set
rank_ivt = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by ivt_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where ivt_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, ivt_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_pdt
update dibots_v2.broker_rank_qtr a
set
rank_pdt = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by pdt_trade_value desc) rank
from dibots_v2.broker_rank_qtr
where pdt_trade_value is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, pdt_trade_value) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_algo
update dibots_v2.broker_rank_qtr a
set
rank_algo = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by algo_count desc) rank
from dibots_v2.broker_rank_qtr
where algo_count is not null and algo_count <> 0 and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, algo_count) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_inet
update dibots_v2.broker_rank_qtr a
set
rank_inet = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by inet_count desc) rank
from dibots_v2.broker_rank_qtr
where inet_count is not null and inet_count <> 0 and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, inet_count) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_dma
update dibots_v2.broker_rank_qtr a
set
rank_dma = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by dma_count desc) rank
from dibots_v2.broker_rank_qtr
where dma_count is not null and dma_count <> 0 and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, dma_count) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;


-- rank_brok
update dibots_v2.broker_rank_qtr a
set
rank_brok = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by brok_count desc) rank
from dibots_v2.broker_rank_qtr
where brok_count is not null and brok_count <> 0 and year >= 2022 and qtr >= 1
group by year, qtr, participant_code, brok_count) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_buy_vol
update dibots_v2.broker_rank_qtr a
set
rank_buy_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_vol desc) rank
from dibots_v2.broker_rank_qtr
where buy_vol is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_buy_val
update dibots_v2.broker_rank_qtr a
set
rank_buy_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_val desc) rank
from dibots_v2.broker_rank_qtr
where buy_val is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_sell_vol
update dibots_v2.broker_rank_qtr a
set
rank_sell_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_vol desc) rank
from dibots_v2.broker_rank_qtr
where sell_vol is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

-- rank_sell_val
update dibots_v2.broker_rank_qtr a
set
rank_sell_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_val desc) rank
from dibots_v2.broker_rank_qtr
where sell_val is not null and year >= 2022 and qtr >= 1
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

