
-- market local_inst and foreign_inst vol and val
select extract(year from trading_date), extract(month from trading_date), sum(local_inst_volume) as local_inst_vol, sum(local_inst_value)::numeric(25,0) as local_inst_val,
sum(foreign_inst_volume) as foreign_inst_vol, sum(foreign_inst_value)::numeric(25,0) as foreign_inst_val
from dibots_v2.exchange_demography_stock_broker_group
where trading_date >= '2019-01-01'
group by extract(year from trading_date), extract(month from trading_date)


-- mibb local_inst and foreign_inst vol and val
select extract(year from trading_date), extract(month from trading_date), sum(local_inst_volume) as local_inst_vol, sum(local_inst_value)::numeric(25,0) as local_inst_val,
sum(foreign_inst_volume) as foreign_inst_vol, sum(foreign_inst_value)::numeric(25,0) as foreign_inst_val
from dibots_v2.exchange_demography_stock_broker_group
where trading_date >= '2019-01-01' and participant_code = 98
group by extract(year from trading_date), extract(month from trading_date)

-- top 200 traded value stocks in last 12 months
select a.stock_code, a.stock_name, b.market_capitalisation, sum(a.total_val)::numeric(25,0) as value_traded
from dibots_v2.exchange_demography_stock_week a, dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and b.transaction_date = '2022-06-30' and a.trading_date between '2021-07-01' and '2022-06-30'
group by a.stock_code, a.stock_name, b.market_capitalisation
order by sum(coalesce(a.total_val,0)) desc limit 200