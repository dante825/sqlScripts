--==============================
-- DATA MINING for KENANGA
--==============================

-- STRCWARR board trade volume and value

select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' and board = 'STRCWARR'
group by extract(year from trading_date), extract(month from trading_date)

select a.year, a.month, a.volume/b.volume*100::numeric(25,2) as vol_pct, a.value/b.value*100::numeric(25,2) as val_pct
from
(select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' and board = 'STRCWARR'
group by extract(year from trading_date), extract(month from trading_date)) a,
(select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' 
group by extract(year from trading_date), extract(month from trading_date))b
where a.year = b.year and a.month = b.month

-- trade volume and value of all the warrants

select DISTINCT SECURITY_TYPE from dibots_v2.exchange_daily_transaction where transaction_date = '2021-03-24' and security_type like '%WARRANT%' AND board <> 'STRCWARR'

select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type = 'TSR / WARRANT' and
a.trading_date between '2021-01-01' and '2021-04-30' 
group by extract(year from trading_date), extract(month from trading_date)


select a.year, a.month, a.volume/b.volume*100::numeric(25,2) as vol_pct, a.value/b.value*100::numeric(25,2) as val_pct
from
(select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type = 'TSR / WARRANT' and
a.trading_date between '2021-01-01' and '2021-04-30' 
group by extract(year from trading_date), extract(month from trading_date)) a,
(select extract(year from trading_date) as year, extract(month from trading_date) as month, sum(total_volume) as volume, sum(total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' 
group by extract(year from trading_date), extract(month from trading_date))b
where a.year = b.year and a.month = b.month


--============================================

--TOP traded structured warrants by volume
select stock_code, stock_name, sum(total_volume) as volume from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' and board = 'STRCWARR'
group by stock_code, stock_name
order by sum(total_volume) desc limit 10

-- TOP traded TSR / WARRANTS by volume
select a.stock_code, a.stock_name, sum(a.total_volume) as volume
from dibots_v2.exchange_demography_stock_broker_group a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type = 'TSR / WARRANT' and
a.trading_date between '2021-01-01' and '2021-04-30' 
group by a.stock_code, a.stock_name
order by sum(a.total_volume) desc limit 10;


-- TOP traded structured warrants by value
select stock_code, stock_name, sum(total_value)::numeric(25,0) as value from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2021-01-01' and '2021-04-30' and board = 'STRCWARR'
group by stock_code, stock_name
order by sum(total_value) desc limit 10

-- TOP traded TSR / WARRANTS by value
select a.stock_code, a.stock_name, sum(a.total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type = 'TSR / WARRANT' and
a.trading_date between '2021-01-01' and '2021-04-30'
group by a.stock_code, a.stock_name
order by sum(a.total_value) desc limit 10;


-- TOP traded strcwarr or TSR/WARRANTS by volume
select a.stock_code, a.stock_name, sum(a.total_volume) as volume 
from dibots_v2.exchange_demography_stock_broker_group a
where a.trading_date between '2021-01-01' and '2021-04-30' and (a.stock_code in (select stock_code from dibots_v2.exchange_daily_transaction where transaction_date = '2021-05-10' and security_type = 'TSR / WARRANT')
OR a.board = 'STRCWARR')
group by a.stock_code, a.stock_name
order by sum(a.total_volume) desc limit 10;


-- TOP traded strcwarr or TSR/WARRANTS by value
select a.stock_code, a.stock_name, sum(a.total_value)::numeric(25,0) as value
from dibots_v2.exchange_demography_stock_broker_group a
where a.trading_date between '2021-01-01' and '2021-04-30' and (a.stock_code in (select stock_code from dibots_v2.exchange_daily_transaction where transaction_date = '2021-05-10' and security_type = 'TSR / WARRANT')
OR a.board = 'STRCWARR')
group by a.stock_code, a.stock_name
order by sum(a.total_value) desc limit 10;
