-- Index calculation test

-- Selected stocks: PMETAL, KOSSAN, PUBLIC BANK, MAYBANK, INARI
-- start date = 2022-01-01

--===========================
-- price weighted index
-- the bonus issue and share split are accomodated by changing the divisor
-- https://www.investopedia.com/articles/investing/082714/what-dow-means-and-why-we-calculate-it-way-we-do.asp

-- using closing price
select transaction_date, sum(closing_price)/5 as index from (
select transaction_date, stock_code, stock_name_short, closing_price, market_capitalisation, closing_price * market_capitalisation as val
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by transaction_date 
order by transaction_date asc

-- using adj_closing price
select transaction_date, sum(adj_closing)/5 as index from (
select transaction_date, stock_code, stock_name_short, adj_closing
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by transaction_date 
order by transaction_date asc

-- rebased to 1000
-- the val / first_day_value * desired base value

-- using closing price
select transaction_date, sum(closing_price)/5/4.81*1000 as index from (
select transaction_date, stock_code, stock_name_short, closing_price, market_capitalisation, closing_price * market_capitalisation as val
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by transaction_date 
order by transaction_date asc

-- using adj_closing
select transaction_date, (sum(adj_closing)/5)/21.3440752*1000 as index from (
select transaction_date, stock_code, stock_name_short, adj_closing
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by transaction_date 
order by transaction_date asc

--===============================
-- simple average with weightage
--===============================

select c.transaction_date as trading_date, sum(c.weighted_adj_closing)/ count(*) from 
(select a.transaction_date, a.stock_code, a.stock_name_short, a.adj_closing, a.volume_traded_market_transaction, b.stock_code, b.weightage, a.adj_closing * b.weightage as weighted_adj_closing
from dibots_user_pref.exchange_daily_transaction_view a 
inner join dibots_user_pref.user_index_stocks b on a.stock_code = b.stock_code and b.index_id = 2 
where a.transaction_date >= '2019-01-01'
--order by a.transaction_date asc, a.stock_code asc
) c
group by c.transaction_date order by c.transaction_date asc

--=======================================================
-- index group calculation simple average with weightage
--=======================================================

select c.trading_date, sum(c.product) / count(*) from (
select a.trading_date, a.index_id, a.index_value, b.weightage, a.index_value * b.weightage as product from dibots_user_pref.user_index_value a
inner join dibots_user_pref.user_index_group_details b on a.index_id = b.index_id and b.group_id = 7
union
select a.trading_date, a.index_id, a.close, b.weightage, a.close * weightage as product from dibots_user_pref.sector_index_view a
inner join dibots_user_pref.user_index_group_details b on a.index_id = b.index_id and b.group_id = 7
) c
where c.trading_date >= '2019-01-01'
group by c.trading_date
order by trading_date asc


--=======================
-- weighted average with prior closing price

-- need a window function to get the prior day data to calculate the last step
select a.transaction_date, sum(a.closing - (a.closing / a.y_closing))/5 as tmp
from (
select transaction_date, stock_code, stock_name_short, closing_price as closing, y_closing, y_factor, y_closing * y_factor as y_adj_closing, adj_closing
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by a.transaction_date order by a.transaction_date asc;

select * from dibots_v2.exchange_daily_transaction order by transaction_date desc

-- market cap weighted
-- https://www.investopedia.com/terms/c/capitalizationweightedindex.asp

select transaction_date, sum(val)/sum(market_capitalisation) from (
select transaction_date, stock_code, stock_name_short, closing_price, market_capitalisation, closing_price * market_capitalisation as val
from dibots_v2.exchange_daily_transaction where transaction_date > '2022-01-01' and stock_code in ('8869', '7153', '1295', '1155', '0166')
order by transaction_date, stock_code) a
group by transaction_date 
order by transaction_date asc

-- how to rebase the index? first day 1000, then proceed from there

-- result = 1434.50806, official: 1437.52
select sum(adj_closing)/30 as avg_adj_closing, sum(closing_price)/30 as avg_closing, sum(closing_price / y_closing)/30, sum(closing_price / y_closing)/30 * 1449.74
from dibots_v2.exchange_daily_transaction where transaction_date  = '2022-07-04' and klci_flag = true

-- result: 1443.00672, official: 1449.74 OFFICIAL INCREASES BUT THIS DECREASED WHY
select sum(adj_closing)/30 as avg_adj_closing, sum(closing_price)/30 as avg_closing, sum(closing_price / y_closing)/30, sum(closing_price / y_closing)/30 * 1444.22
from dibots_v2.exchange_daily_transaction where transaction_date  = '2022-07-01' and klci_flag = true

-- result = 1445.31113, official number: 1444.22, the index decreases, still close enough
select sum(adj_closing)/30 as avg_adj_closing, sum(closing_price)/30 as avg_closing, sum(closing_price / y_closing)/30, sum(closing_price / y_closing)/30 * 1451.48
from dibots_v2.exchange_daily_transaction where transaction_date  = '2022-06-30' and klci_flag = true

-- result = 1602.06518, official: 1602.41
select sum(adj_closing)/30 as avg_adj_closing, sum(closing_price)/30 as avg_closing, sum(closing_price / y_closing)/30, sum(closing_price / y_closing)/30 * 1587.36
from dibots_v2.exchange_daily_transaction where transaction_date  = '2022-04-01' and klci_flag = true

select sum(b.closing_price / a.closing_price) / 30 as closing, sum(b.adj_closing / a.adj_closing)/30 as adj_closing,
sum(b.market_capitalisation / a.market_capitalisation) / 30 as market_cap, sum(b.market_capitalisation / a.market_capitalisation) / 30 * 1444.22 as new_index_market_cap,
sum(b.adj_closing / a.adj_closing) / 30 * 1444.22 as new_index_adj_closing
from 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2022-06-30' and klci_flag = true) a,
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-01' and klci_flag = true) b
where a.stock_code = b.stock_code

-- marketcap weighting
select stock_code, market_capitalisation / 971152229767.36 * 100 as index_weight from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-01' and klci_flag = true
order by stock_code

select sum(a.ratio * b.index_weight) / 30 * 1444.22
--select a.stock_code, a.ratio, b.index_weight, a.ratio * index_weight
from
(select stock_code, closing_price / y_closing as ratio from dibots_v2.exchange_daily_transaction where transaction_date  = '2022-07-01' and klci_flag = true) a,
(select stock_code, market_capitalisation / 971152229767.36 * 100 as index_weight from dibots_v2.exchange_daily_transaction where transaction_date = '2022-07-01' and klci_flag = true) b
where a.stock_code = b.stock_codeselect a.stock_code, a.stock_name, b.market_capitalisation, sum(a.total_val)::numeric(25,0) as value_traded
from dibots_v2.exchange_demography_stock_week a, dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and b.transaction_date = '2022-06-30' and a.trading_date between '2021-07-01' and '2022-06-30'
group by a.stock_code, a.stock_name, b.market_capitalisation
order by sum(coalesce(a.total_val,0)) desc limit 200

select * from dibots_v2.exchange_daily_sector_index where sector = 'KLCI' order by transaction_date desc


--=============================================================
-- QUERY to get previous values

select a.trading_date, a.index_id, a.index_value, a.rebased_index, lag(trading_date) over index_window as pre_trading_date, lag(index_value) over index_window as pre_index_value, lag(rebased_index) over index_window as pre_rebased_index
from dibots_user_pref.user_index_value a where index_id = 1
window index_window as (partition by index_id order by trading_date)
order by a.trading_date

-- REFERENCE: https://backtest.curvo.eu


--=====================
-- STANDARD DEVIATION
--=====================

-- sql stddev function
select stddev(idx_chg_pct), stddev_pop(idx_chg_pct), stddev(rebased_idx_chg_pct), stddev_pop(rebased_idx_chg_pct) from (
select b.trading_date, b.index_id, b.index_value, b.pre_index_value, (b.index_value - coalesce(b.pre_index_value,0)) / b.pre_index_value * 100 as idx_chg_pct, b.rebased_index, b.pre_rebased_index,
(b.rebased_index - coalesce(b.pre_rebased_index,0)) / b.pre_rebased_index * 100 as rebased_idx_chg_pct, b.pre_trading_date
from
(select a.trading_date, a.index_id, a.index_value, a.rebased_index, lag(trading_date) over index_window as pre_trading_date, lag(index_value) over index_window as pre_index_value, lag(rebased_index) over index_window as pre_rebased_index
from dibots_user_pref.user_index_value a where index_id = 1
window index_window as (partition by index_id order by trading_date)
order by a.trading_date) b
where pre_trading_date is not null and index_id = 1 and trading_date >= '2022-07-01'
) c

-- manual std dev calculation
select sqrt(sum(pow(idx_chg_pct - (0.00206),2))/391), sqrt(sum(pow(rebased_idx_chg_pct - (0.00206),2))/391) from (
--select sum(idx_chg_pct) as sum_chg, sum(rebased_idx_chg_pct) as sum_rebased, sum(idx_chg_pct)/391 as avg_chg, sum(rebased_idx_chg_pct)/391 avg_rebased, avg(idx_chg_pct), avg(rebased_idx_chg_pct) from (
select b.trading_date, b.index_id, b.index_value, b.pre_index_value, (b.index_value - coalesce(b.pre_index_value,0)) / b.pre_index_value * 100 as idx_chg_pct, b.rebased_index, b.pre_rebased_index,
(b.rebased_index - coalesce(b.pre_rebased_index,0)) / b.pre_rebased_index * 100 as rebased_idx_chg_pct, b.pre_trading_date
from
(select a.trading_date, a.index_id, a.index_value, a.rebased_index, lag(trading_date) over index_window as pre_trading_date, lag(index_value) over index_window as pre_index_value, lag(rebased_index) over index_window as pre_rebased_index
from dibots_user_pref.user_index_value a where index_id = 12
window index_window as (partition by index_id order by trading_date)
order by a.trading_date) b
where index_id = 12 and trading_date >= '2021-01-01'
order by trading_date asc
) c

--the manual stddev calculation is same with stddev_pop function
-- stddev divide by n-1 while stddev_pop divide by n


--=============================
-- COMPOUND ANNUAL GROWTH RATE
--=============================

-- CAGR = ((final index value / total amount invested)^(1/fractional number of years) ) - 1

-- for example: user selected an index from 2021-01-01 to 2022-05-31
-- on 2021-01-01 rebased index is 1000
-- on 2022-05-31 rebased index is 1089.2
-- CAGR = ((1089.2/1000)^1/(17/12)) - 1 = (1.0892^(12/17)) - 1 = 0.0620 = 6.2 %

-- by getting the distinct number of month, x / 12 would get the fractional number of years
select distinct extract(year from trading_date), extract(month from trading_date) from dibots_user_pref.user_index_value where index_id = 1 and trading_date between '2021-01-01' and '2022-05-31'


--================
-- SHARPE RATIO
--===============

-- sharpe ratio = mod(portfolio return - risk free return) / stddev of excess return


