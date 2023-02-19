--===========================================================
-- adding buy sell vol val columns to all broker rank tables
--===========================================================

-- 1.broker_rank_day
select * from dibots_v2.broker_rank_day

alter table dibots_v2.broker_rank_day 
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_day a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from 
(select trading_date, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.exchange_demography_stock_broker_group
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_day where total_trade_volume <> buy_vol + sell_vol

update dibots_v2.broker_rank_day a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_day_totals b
where a.trading_date = b.trading_date;

select trading_date, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_day
group by trading_date

update dibots_v2.broker_rank_day a
set
rank_buy_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_vol desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_day a
set
rank_buy_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_val desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_day a
set
rank_sell_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_vol desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_day a
set
rank_sell_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_val desc) rank
from dibots_v2.broker_rank_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_day where trading_date = '2021-08-26'

-- 2. broker_rank_day_totals
select * from dibots_v2.broker_rank_day_totals

alter table dibots_v2.broker_rank_day_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_day_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select trading_date, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val from dibots_v2.broker_rank_day
group by trading_date) b
where a.trading_date = b.trading_date;

select * from dibots_v2.broker_rank_day_totals where total_trade_volume <> buy_vol + sell_vol

-- 3. broker_rank_week
select * from dibots_v2.broker_rank_week

alter table dibots_v2.broker_rank_week
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_week a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select week_count, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_day group by week_count, participant_code) b
where a.week_count = b.week_count and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_week where total_trade_volume <> buy_vol + sell_vol

update dibots_v2.broker_rank_week a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_week_totals b
where a.week_count = b.week_count;

select week_count, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_week
group by week_count

update dibots_v2.broker_rank_week a
set
rank_buy_vol = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by buy_vol desc) rank
from dibots_v2.broker_rank_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_week a
set
rank_buy_val = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by buy_val desc) rank
from dibots_v2.broker_rank_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_week a
set
rank_sell_vol = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by sell_vol desc) rank
from dibots_v2.broker_rank_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_week a
set
rank_sell_val = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by sell_val desc) rank
from dibots_v2.broker_rank_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_week where week_count = '2021-34'

-- 4. broker_rank_week_totals
select * from dibots_v2.broker_rank_week_totals

alter table dibots_v2.broker_rank_week_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_week_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select week_count, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_week group by week_count) b
where a.week_count = b.week_count;

select * from dibots_v2.broker_rank_week_totals where total_trade_volume <> buy_vol + sell_vol

-- 5. broker_rank_month
select * from dibots_v2.broker_rank_month

alter table dibots_v2.broker_rank_month
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_month a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, month, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_day
group by year, month, participant_code) b
where a.year = b.year and a.month = b.month and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_month where total_trade_volume <> buy_vol + sell_vol;

update dibots_v2.broker_rank_month a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_month_totals b
where a.year = b.year and a.month = b.month;

select year, month, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_month
group by year, month

update dibots_v2.broker_rank_month a
set
rank_buy_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_vol desc) rank
from dibots_v2.broker_rank_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_month a
set
rank_buy_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_val desc) rank
from dibots_v2.broker_rank_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_month a
set
rank_sell_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_vol desc) rank
from dibots_v2.broker_rank_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_month a
set
rank_sell_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_val desc) rank
from dibots_v2.broker_rank_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_month where year = 2021 and month = 7

-- 6. broker_rank_month_totals
select * from dibots_v2.broker_rank_month_totals

alter table dibots_v2.broker_rank_month_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_month_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, month, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_month
group by year, month) b
where a.year = b.year and a.month = b.month;

select * from dibots_v2.broker_rank_month_totals where total_trade_volume <> buy_vol + sell_vol;

-- 7. broker_rank_qtr
select * from dibots_v2.broker_rank_qtr

alter table dibots_v2.broker_rank_qtr
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_qtr a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, qtr, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_day
group by year, qtr, participant_code) b
where a.year = b.year and a.qtr = b.qtr and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_qtr where total_trade_volume <> buy_vol + sell_vol;

update dibots_v2.broker_rank_qtr a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_qtr_totals b
where a.year = b.year and a.qtr = b.qtr;

select year, qtr, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_qtr
group by year, qtr

update dibots_v2.broker_rank_qtr a
set
rank_buy_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_vol desc) rank
from dibots_v2.broker_rank_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_qtr a
set
rank_buy_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_val desc) rank
from dibots_v2.broker_rank_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_qtr a
set
rank_sell_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_vol desc) rank
from dibots_v2.broker_rank_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_qtr a
set
rank_sell_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_val desc) rank
from dibots_v2.broker_rank_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_qtr where year = 2021 and qtr = 2

-- 8. broker_rank_qtr_totals
select * from dibots_v2.broker_rank_qtr_totals

alter table dibots_v2.broker_rank_qtr_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_qtr_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, qtr, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_qtr
group by year, qtr) b
where a.year = b.year and a.qtr = b.qtr;

select * from dibots_v2.broker_rank_qtr_totals where total_trade_volume <> buy_vol + sell_vol;

-- 9. broker_rank_year
select * from dibots_v2.broker_rank_year

alter table dibots_v2.broker_rank_year
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_year a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_day 
group by year, participant_code) b
where a.year = b.year and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_year where total_trade_volume <> buy_vol + sell_vol;

update dibots_v2.broker_rank_year a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_year_totals b
where a.year = b.year;

select year, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_year
group by year

update dibots_v2.broker_rank_year a
set
rank_buy_vol = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by buy_vol desc) rank
from dibots_v2.broker_rank_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_year a
set
rank_buy_val = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by buy_val desc) rank
from dibots_v2.broker_rank_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_year a
set
rank_sell_vol = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by sell_vol desc) rank
from dibots_v2.broker_rank_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_year a
set
rank_sell_val = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by sell_val desc) rank
from dibots_v2.broker_rank_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_year where year = 2021

-- 10. broker_rank_year_totals
select * from dibots_v2.broker_rank_year_totals

alter table dibots_v2.broker_rank_year_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_year_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from (
select year, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_year
group by year) b
where a.year = b.year;

select * from dibots_v2.broker_rank_year_totals where total_trade_volume <> buy_vol + sell_vol;

-- 11. broker_rank_wtd
select * from dibots_v2.broker_rank_wtd

alter table dibots_v2.broker_rank_wtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_wtd
set
buy_vol = null,
buy_vol_pct = null,
rank_buy_vol = null,
buy_val = null,
buy_val_pct = null,
rank_buy_val = null,
sell_vol = null,
sell_vol_pct = null,
rank_sell_vol = null,
sell_val = null,
sell_val_pct = null,
rank_sell_val = null;

select trading_date, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_wtd
group by trading_date

select * from dibots_v2.broker_rank_wtd where trading_date = '2021-08-26'

-- 12 . broker_rank_mtd
select * from dibots_v2.broker_rank_mtd;

alter table dibots_v2.broker_rank_mtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

SELECT * from dibots_v2.broker_rank_mtd where trading_date = '2021-05-04'

update dibots_v2.broker_rank_mtd
set
buy_vol = null,
buy_vol_pct = null,
rank_buy_vol = null,
buy_val = null,
buy_val_pct = null,
rank_buy_val = null,
sell_vol = null,
sell_vol_pct = null,
rank_sell_vol = null,
sell_val = null,
sell_val_pct = null,
rank_sell_val = null;

-- 13. broker_rank_qtd
select * from dibots_v2.broker_rank_qtd

alter table dibots_v2.broker_rank_qtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_qtd where trading_date = '2021-08-25'

select trading_date, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct) from dibots_v2.broker_rank_qtd
group by trading_date

update dibots_v2.broker_rank_qtd
set
buy_vol = null,
buy_vol_pct = null,
rank_buy_vol = null,
buy_val = null,
buy_val_pct = null,
rank_buy_val = null,
sell_vol = null,
sell_vol_pct = null,
rank_sell_vol = null,
sell_val = null,
sell_val_pct = null,
rank_sell_val = null;

-- 14. broker_rank_ytd
select * from dibots_v2.broker_rank_ytd

alter table dibots_v2.broker_rank_ytd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_ytd where trading_date = '2021-08-20'

-- 15. broker_rank_omtdbt_day
select * from dibots_v2.broker_rank_omtdbt_day

alter table dibots_v2.broker_rank_omtdbt_day
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_omtdbt_day a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select trading_date, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.exchange_omtdbt_stock_broker_group
group by trading_date, participant_code) b
where a.trading_date = b.trading_date and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_day where total_vol <> buy_vol + sell_vol;

update dibots_v2.broker_rank_omtdbt_day a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_day_totals b
where a.trading_date = b.trading_date;

select trading_date, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_omtdbt_day
group by trading_date

update dibots_v2.broker_rank_omtdbt_day a
set
rank_buy_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_day a
set
rank_buy_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_day a
set
rank_sell_vol = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_day a
set
rank_sell_val = tmp.rank
from
(select trading_date, participant_code, rank() over (partition by trading_date order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_day
group by trading_date, participant_code) tmp
where a.trading_date = tmp.trading_date and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_omtdbt_day where trading_date = '2021-08-25'

-- 16. broker_rank_omtdbt_day_totals
select * from dibots_v2.broker_rank_omtdbt_day_totals

alter table dibots_v2.broker_rank_omtdbt_day_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_omtdbt_day_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select trading_date, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val 
from dibots_v2.broker_rank_omtdbt_day
group by trading_date) b
where a.trading_date = b.trading_date;

select * from dibots_v2.broker_rank_omtdbt_day_totals where total_vol <> buy_vol + sell_vol;

-- 17. broker_rank_omtdbt_week
select * from dibots_v2.broker_rank_omtdbt_week

alter table dibots_v2.broker_rank_omtdbt_week
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_omtdbt_week a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select week_count,participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_day
group by week_count, participant_code) b
where a.week_count = b.week_count and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_week where total_vol <> buy_vol + sell_vol;

update dibots_v2.broker_rank_omtdbt_week a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_week_totals b
where a.week_count = b.week_count;

select week_count, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_omtdbt_week
group by week_count

update dibots_v2.broker_rank_omtdbt_week a
set
rank_buy_vol = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_week a
set
rank_buy_val = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_week a
set
rank_sell_vol = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_week a
set
rank_sell_val = tmp.rank
from
(select week_count, participant_code, rank() over (partition by week_count order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_week
group by week_count, participant_code) tmp
where a.week_count = tmp.week_count and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_omtdbt_week where week_count = '2021-15'

-- 18. broker_rank_omtdbt_week_totals
select * from dibots_v2.broker_rank_omtdbt_week_totals

alter table dibots_v2.broker_rank_omtdbt_week_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_omtdbt_week_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select week_count, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_week
group by week_count) b
where a.week_count = b.week_count;

select * from dibots_v2.broker_rank_omtdbt_week_totals where total_vol <> buy_vol + sell_vol;

-- 19. broker_rank_omtdbt_month
select * from dibots_v2.broker_rank_omtdbt_month

alter table dibots_v2.broker_rank_omtdbt_month
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_omtdbt_month a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select year, month, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_day
group by year, month, participant_code) b
where a.year = b.year and a.month = b.month and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_month where total_vol <> buy_vol + sell_vol;

update dibots_v2.broker_rank_omtdbt_month a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_month_totals b
where a.year = b.year and a.month = b.month;

select year, month, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_omtdbt_month
group by year, month

update dibots_v2.broker_rank_omtdbt_month a
set
rank_buy_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_month a
set
rank_buy_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_month a
set
rank_sell_vol = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_month a
set
rank_sell_val = tmp.rank
from
(select year, month, participant_code, rank() over (partition by year, month order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_month
group by year, month, participant_code) tmp
where a.year = tmp.year and a.month = tmp.month and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_omtdbt_month where year = 2021 and month = 5

select sum(buy_vol), sum(buy_val), sum(sell_vol), sum(sell_val) from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date between '2021-05-01' and '2021-05-31' and participant_code = 31

-- 20. broker_rank_omtdbt_month_totals
select * from dibots_v2.broker_rank_omtdbt_month_totals

alter table dibots_v2.broker_rank_omtdbt_month_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_omtdbt_month_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select year, month, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_month
group by year, month) b
where a.year = b.year and a.month = b.month;

select * from dibots_v2.broker_rank_omtdbt_month_totals where total_vol <> buy_vol + sell_vol;

-- 21. broker_rank_omtdbt_qtr
select * from dibots_v2.broker_rank_omtdbt_qtr

alter table dibots_v2.broker_rank_omtdbt_qtr
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_omtdbt_qtr a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from 
(select year, qtr, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_day 
group by year, qtr, participant_code) b
where a.year = b.year and a.qtr = b.qtr and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_qtr where total_vol <> buy_vol + sell_vol;

update dibots_v2.broker_rank_omtdbt_qtr a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_qtr_totals b
where a.year = b.year and a.qtr = b.qtr;

select year, qtr, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr

update dibots_v2.broker_rank_omtdbt_qtr a
set
rank_buy_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_qtr a
set
rank_buy_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_qtr a
set
rank_sell_vol = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_qtr a
set
rank_sell_val = tmp.rank
from
(select year, qtr, participant_code, rank() over (partition by year, qtr order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr, participant_code) tmp
where a.year = tmp.year and a.qtr = tmp.qtr and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_omtdbt_qtr where year = 2021 and qtr = 1

-- 22. broker_rank_omtdbt_qtr_totals
select * from dibots_v2.broker_rank_omtdbt_qtr_totals

alter table dibots_v2.broker_rank_omtdbt_qtr_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_omtdbt_qtr_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select year, qtr, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_qtr
group by year, qtr) b
where a.year = b.year and a.qtr = b.qtr;

select * from dibots_v2.broker_rank_omtdbt_qtr_totals where total_vol <> buy_vol + sell_vol;

-- 23. broker_rank_omtdbt_year
select * from dibots_v2.broker_rank_omtdbt_year

alter table dibots_v2.broker_rank_omtdbt_year
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

update dibots_v2.broker_rank_omtdbt_year a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from
(select year, participant_code, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_day
group by year, participant_code) b
where a.year = b.year and a.participant_code = b.participant_code;

select * from dibots_v2.broker_rank_omtdbt_year where total_vol <> buy_vol + sell_vol;

update dibots_v2.broker_rank_omtdbt_year a
set
buy_vol_pct = cast(a.buy_vol as numeric(25,3))/cast(b.buy_vol as numeric(25,3))*100,
buy_val_pct = a.buy_val/b.buy_val*100,
sell_vol_pct = cast(a.sell_vol as numeric(25,3))/cast(b.sell_vol as numeric(25,3))*100,
sell_val_pct = a.sell_val/b.sell_val* 100
from dibots_v2.broker_rank_omtdbt_year_totals b
where a.year = b.year;

select year, sum(buy_vol_pct), sum(buy_val_pct), sum(sell_vol_pct), sum(sell_val_pct)
from dibots_v2.broker_rank_omtdbt_year
group by year

update dibots_v2.broker_rank_omtdbt_year a
set
rank_buy_vol = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by buy_vol desc) rank
from dibots_v2.broker_rank_omtdbt_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_year a
set
rank_buy_val = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by buy_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_year a
set
rank_sell_vol = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by sell_vol desc) rank
from dibots_v2.broker_rank_omtdbt_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

update dibots_v2.broker_rank_omtdbt_year a
set
rank_sell_val = tmp.rank
from
(select year, participant_code, rank() over (partition by year order by sell_val desc) rank
from dibots_v2.broker_rank_omtdbt_year
group by year, participant_code) tmp
where a.year = tmp.year and a.participant_code = tmp.participant_code;

select * from dibots_v2.broker_rank_omtdbt_year where year = 2021

-- 24. broker_rank_omtdbt_year_totals
select * from dibots_v2.broker_rank_omtdbt_year_totals

alter table dibots_v2.broker_rank_omtdbt_year_totals add column buy_vol bigint, add column buy_val numeric(32,5), add column sell_vol bigint, add column sell_val numeric(32,5);

update dibots_v2.broker_rank_omtdbt_year_totals a
set
buy_vol = b.buy_vol,
buy_val = b.buy_val,
sell_vol = b.sell_vol,
sell_val = b.sell_val
from 
(select year, sum(buy_vol) as buy_vol, sum(buy_val) as buy_val, sum(sell_vol) as sell_vol, sum(sell_val) as sell_val
from dibots_v2.broker_rank_omtdbt_year
group by year) b
where a.year = b.year;

select * from dibots_v2.broker_rank_omtdbt_year where total_vol <> buy_vol + sell_vol;

-- 25. broker_rank_omtdbt_wtd
select * from dibots_v2.broker_rank_omtdbt_wtd;

alter table dibots_v2.broker_rank_omtdbt_wtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_omtdbt_wtd where trading_date = '2021-08-20'

-- 26. broker_rank_omtdbt_mtd
select * from dibots_v2.broker_rank_omtdbt_mtd;

alter table dibots_v2.broker_rank_omtdbt_mtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_omtdbt_mtd where trading_date = '2021-08-02'

-- 27. broker_rank_omtdbt_qtd
select * from dibots_v2.broker_rank_omtdbt_qtd;

alter table dibots_v2.broker_rank_omtdbt_qtd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_omtdbt_qtd where trading_date = '2021-08-23'

-- 28. broker_rank_omtdbt_ytd
select * from dibots_v2.broker_rank_omtdbt_ytd;

alter table dibots_v2.broker_rank_omtdbt_ytd
add column buy_vol bigint, add column buy_vol_pct numeric(10,2), add column rank_buy_vol int, 
add column buy_val numeric(32,5), add column buy_val_pct numeric(10,2), add column rank_buy_val int,
add column sell_vol bigint, add column sell_vol_pct numeric(10,2), add column rank_sell_vol int,
add column sell_val bigint, add column sell_val_pct numeric(10,2), add column rank_sell_val int;

select * from dibots_v2.broker_rank_omtdbt_ytd where trading_date = '2021-08-02'



-- vacuum
vacuum (analyze) dibots_v2.exchange_demography;
vacuum (analyze) dibots_v2.exchange_daily_avg;
vacuum (analyze) dibots_v2.exchange_daily_sector_index;
vacuum (analyze) dibots_v2.exchange_weekly_sector_index;
vacuum (analyze) dibots_v2.exchange_daily_transaction;
vacuum (analyze) dibots_v2.exchange_weekly_transaction;
vacuum (analyze) dibots_v2.exchange_daily_transaction_velocity;
vacuum (analyze) dibots_v2.exchange_dbt_broker_age_band;
vacuum (analyze) dibots_v2.exchange_dbt_broker_movement;
vacuum (analyze) dibots_v2.exchange_dbt_broker_nationality;
vacuum (analyze) dibots_v2.exchange_dbt_broker_stats;
vacuum (analyze) dibots_v2.exchange_dbt_stock;
vacuum (analyze) dibots_v2.exchange_dbt_stock_broker;
vacuum (analyze) dibots_v2.exchange_dbt_stock_broker_group;
vacuum (analyze) dibots_v2.exchange_dbt_stock_movement;
vacuum (analyze) dibots_v2.exchange_demography;
vacuum (analyze) dibots_v2.exchange_demography_broker_age_band;
vacuum (analyze) dibots_v2.exchange_demography_broker_movement;
vacuum (analyze) dibots_v2.exchange_demography_broker_nationality;
vacuum (analyze) dibots_v2.exchange_demography_broker_stats;
vacuum (analyze) dibots_v2.exchange_demography_nationality;
vacuum (analyze) dibots_v2.exchange_demography_stats;
vacuum (analyze) dibots_v2.exchange_demography_stock_age_band;
vacuum (analyze) dibots_v2.exchange_demography_stock_broker;
vacuum (analyze) dibots_v2.exchange_demography_stock_broker_group;
vacuum (analyze) dibots_v2.exchange_demography_stock_broker_stats;
vacuum (analyze) dibots_v2.exchange_demography_stock_movement;
vacuum (analyze) dibots_v2.exchange_demography_stock_week;
vacuum (analyze) dibots_v2.exchange_direct_business_trade;
vacuum (analyze) dibots_v2.exchange_omtdbt_broker_age_band;
vacuum (analyze) dibots_v2.exchange_omtdbt_broker_movement;
vacuum (analyze) dibots_v2.exchange_omtdbt_broker_nationality;
vacuum (analyze) dibots_v2.exchange_omtdbt_broker_stats;
vacuum (analyze) dibots_v2.exchange_omtdbt_stock;
vacuum (analyze) dibots_v2.exchange_omtdbt_stock_broker;
vacuum (analyze) dibots_v2.exchange_omtdbt_stock_broker_group;
vacuum (analyze) dibots_v2.exchange_omtdbt_stock_movement;
vacuum (analyze) dibots_v2.broker_rank_day;
vacuum (analyze) dibots_v2.broker_rank_day_totals;
vacuum (analyze) dibots_v2.broker_rank_week;
vacuum (analyze) dibots_v2.broker_rank_week_totals;
vacuum (analyze) dibots_v2.broker_rank_month;
vacuum (analyze) dibots_v2.broker_rank_month_totals;
vacuum (analyze) dibots_v2.broker_rank_qtr;
vacuum (analyze) dibots_v2.broker_rank_qtr_totals;
vacuum (analyze) dibots_v2.broker_rank_year;
vacuum (analyze) dibots_v2.broker_rank_year_totals;
vacuum (analyze) dibots_v2.broker_rank_wtd;
vacuum (analyze) dibots_v2.broker_rank_mtd;
vacuum (analyze) dibots_v2.broker_rank_qtd;
vacuum (analyze) dibots_v2.broker_rank_ytd;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_day;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_day_totals;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_week;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_week_totals;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_month;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_month_totals;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_qtr;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_qtr_totals;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_year;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_year_totals;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_wtd;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_mtd;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_qtd;
vacuum (analyze) dibots_v2.broker_rank_omtdbt_ytd;
