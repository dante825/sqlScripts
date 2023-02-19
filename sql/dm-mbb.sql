--=========================
-- MAYBANK IB DATA REQUEST
--=========================

--=====================
-- OVERALL MARKET
--=====================

-- OMT VALUE
select year, month, sum(total_trade_value)::numeric(25,0) from dibots_v2.broker_rank_month where year >= 2020
group by year, month
order by year, month

select extract(year from trading_date), extract(month from trading_date), sum(total_value)::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group where trading_date >= '2020-01-01'
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);


-- DBT VALUE
select extract(year from trading_date), extract(month from trading_date), sum(total_val)::numeric(25,0) from dibots_v2.exchange_dbt_stock_broker_group where trading_date >= '2020-01-01' 
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);

-- OMT + DBT VALUE
select extract(year from trading_date), extract(month from trading_date), sum(total_val)::numeric(25,0) from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date >= '2020-01-01' 
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);

-- INTRADAY
select extract(year from trading_date), extract(month from trading_date), sum(total_intraday_val)::numeric(25,0) as intraday from dibots_v2.exchange_demography_stock_week 
where trading_date >= '2020-01-01' 
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date)


-- ORDER COUNT & ORDER / TRADE
select year, month, sum(ord_count) as order, sum(trd_count) as trade, sum(ord_count)/sum(trd_count) as ot_ratio from dibots_v2.broker_rank_month where year >= 2020
group by year, month
order by year, month


-- ORDER ORIGIN VALUE
-- INET
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 4
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- BROK
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 2
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- ALGO
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 1
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- DMA
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 3
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);



-- ORDER ORIGIN ORDERS
select year, month, sum(algo_count)::numeric(25,0) as algo, sum(inet_count)::numeric(25,0) as inet, sum(dma_count)::numeric(25,0) as dma, sum(brok_count)::numeric(25,0) as brok 
from dibots_v2.broker_rank_month where year >= 2020
group by year, month order by year, month

-- trade origin for market
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31'
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc

select trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31'
group by trade_origin, trade_origin_code
order by trade_origin asc


-- trade origin for MBB with pct

select a.year, a.month, a.trade_origin, b.value, b.volume, (b.value/a.value*100)::numeric(25,2) as val_pct, (b.volume/a.volume*100)::numeric(25,2) as vol_pct from
(select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31'
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc) a
left join
(select extract(year from trading_date) as year, extract(month from trading_date) as month, trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31' and broker_code = 98
group by extract(year from trading_date), extract(month from trading_date), trade_origin, trade_origin_code
order by extract(year from trading_date) asc, extract(month from trading_date) asc, trade_origin asc) b
on a.year = b.year and a.month = b.month and a.trade_origin = b.trade_origin

select a.trade_origin, b.value, b.volume, (b.value/a.value*100)::numeric(25,2) as val_pct, (b.volume/a.volume*100)::numeric(25,2) as vol_pct from
(select trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31'
group by trade_origin, trade_origin_code
order by trade_origin asc) a
left join
(select trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date between '2021-01-01' and '2021-12-31' and broker_code = 98
group by trade_origin, trade_origin_code
order by trade_origin asc) b
on a.trade_origin = b.trade_origin


--=================
-- MAYBANK IB
--=================

-- OMT VALUE
select year, month, sum(total_trade_value)::numeric(25,0) from dibots_v2.broker_rank_month where year >= 2020 and participant_code = 98
group by year, month
order by year, month


select extract(year from trading_date), extract(month from trading_date), sum(total_value)::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group where trading_date >= '2020-01-01' and participant_code = 98
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);


-- DBT VALUE
select extract(year from trading_date), extract(month from trading_date), sum(total_val)::numeric(25,0) from dibots_v2.exchange_dbt_stock_broker_group where trading_date >= '2020-01-01' and participant_code = 98
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);

-- OMT + DBT VALUE
select extract(year from trading_date), extract(month from trading_date), sum(total_val)::numeric(25,0) from dibots_v2.exchange_omtdbt_stock_broker_group where trading_date >= '2020-01-01' and participant_code = 98
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date);

-- ORDER COUNT & ORDER / TRADE
select year, month, sum(ord_count) as order, sum(trd_count) as trade, sum(ord_count)/sum(trd_count) as ot_ratio from dibots_v2.broker_rank_month where year >= 2020 and participant_code = 98
group by year, month
order by year, month

-- INTRADAY
select extract(year from trading_date), extract(month from trading_date), sum(total_intraday_val)::numeric(25,0) as intraday from dibots_v2.exchange_demography_stock_broker_group
where trading_date >= '2020-01-01' and participant_code = 98
group by extract(year from trading_date), extract(month from trading_date)
order by extract(year from trading_date), extract(month from trading_date)


-- ORDER ORIGIN VALUE
-- INET
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 4 and broker_code = 98
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- BROK
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 2 and broker_code = 98
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- ALGO
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 1 and broker_code = 98
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- DMA
select extract(year from trading_date), extract(month from trading_date), trade_origin, sum(trade_value)::numeric(25,0) as value, sum(trade_quantity) as volume
from dibots_v2.exchange_trade_origin where trading_date >= '2020-01-01' and trade_origin_code = 3 and broker_code = 98
group by extract(year from trading_date), extract(month from trading_date), trade_origin
order by extract(year from trading_date), extract(month from trading_date);

-- ORDER ORIGIN ORDERS
select year, month, sum(algo_count)::numeric(25,0) as algo, sum(inet_count)::numeric(25,0) as inet, sum(dma_count)::numeric(25,0) as dma, sum(brok_count)::numeric(25,0) as brok 
from dibots_v2.broker_rank_month where year >= 2020 and participant_code = 98
group by year, month order by year, month

--=================

-- GENDER

select gender, sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0))::numeric(25,0)  from dibots_v2.exchange_demography where trading_date between '2021-01-01' and '2021-10-22'
group by gender

select gender, sum(coalesce(gross_traded_value_buy,0) + coalesce(gross_traded_value_sell,0))::numeric(25,0)  from dibots_v2.exchange_demography 
where trading_date between '2021-01-01' and '2021-10-22' and participant_code = 98
group by gender

-- AGE GROUP
select age_band, sum(total_buysell_value)::numeric(25,0) from dibots_v2.exchange_demography_broker_age_band
where trading_date between '2021-01-01' and '2021-10-22'
group by age_band order by age_band

select age_band, sum(total_buysell_value)::numeric(25,0), sum(total_buysell_value)/538419840568*100 as pct from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22'
group by age_band order by age_band

select age_band, sum(total_buysell_value)::numeric(25,0), sum(total_buysell_value)/35832925099.91*100 as pct from dibots_v2.exchange_demography_broker_age_band 
where trading_date between '2021-01-01' and '2021-10-22' and participant_code = 98
group by age_band order by age_band

select sum(total_buysell_value)::numeric(25,0) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22'

select sum(total_buysell_value) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22' and participant_code = 98

select sum(total_buysell_value) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22' and age_band in ('18 - 19', '20 - 24', '25 - 29', '30 - 34')

select sum(total_buysell_value) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22' and age_band in ('18 - 19', '20 - 24', '25 - 29', '30 - 34') and participant_code = 98


select sum(total_buysell_value) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22' and age_band in ('35 - 39','40 - 44','45 - 49','50 - 54','55 - 59','60 - 64')

select sum(total_buysell_value) from dibots_v2.exchange_demography_broker_age_band where trading_date between '2021-01-01' and '2021-10-22' and age_band in ('35 - 39','40 - 44','45 - 49','50 - 54','55 - 59','60 - 64') and participant_code = 98

--F4GBM stocks fund flow
select a.stock_code, sum(a.local_inst_vol) as local_inst_vol, sum(a.local_inst_val) as local_inst_val, sum(a.local_retail_vol) as local_retail_vol, sum(a.local_retail_val) as local_retail_val,
sum(a.local_nominees_vol) as local_nom_vol, sum(a.local_nominees_val) as local_nominees_val, sum(a.foreign_vol) as foreign_vol, sum(a.foreign_val) as foreign_val, sum(coalesce(a.ivt_vol,0) + coalesce(a.pdt_vol,0)) as prop_vol,
sum(coalesce(a.ivt_val,0) + coalesce(a.pdt_val,0)) as prop_val,
sum(a.net_local_inst_vol) as net_local_inst_vol, sum(a.net_local_inst_val) as net_local_inst_val, sum(a.net_local_retail_vol) as net_local_retail_vol, sum(a.net_local_retail_val) as net_local_retail_val,
sum(a.net_local_nominees_vol) as net_local_nom_vol, sum(a.net_local_nominees_val) as net_local_nom_val, sum(a.net_foreign_vol) as net_foreign_vol, sum(a.net_foreign_val) as net_foreign_val, 
sum(coalesce(a.net_ivt_vol,0) + coalesce(a.net_pdt_vol,0)) as net_prop_vol, sum(coalesce(a.net_ivt_val,0) + coalesce(a.net_pdt_val,0)) as net_prop_val
from dibots_v2.exchange_demography_stock_week a, dibots_v2.ref_demography_stock b
where a.trading_date = b.trading_date and a.stock_num = b.stock_num and b.f4gbm_flag = true
and a.trading_date between '2021-01-01' and '2021-12-21'
group by a.stock_code
order by a.stock_code asc


-- Marketcap RM 500m to RM 1b
select stock_code, stock_name_short, board, sector, market_capitalisation, rank_overall
from dibots_v2.exchange_daily_transaction where transaction_date = '2022-06-16' and market_capitalisation >= 500000000 and market_capitalisation < 1000000000
and rank_overall is not null
order by market_capitalisation desc