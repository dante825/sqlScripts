--  EXCHANGE_STOCK_LIQUIDITY_MEDIAN

--drop table dibots_v2.exchange_stock_liquidity_median;
create table dibots_v2.exchange_stock_liquidity_median (
year int,
month int,
min_trading_date date,
max_trading_date date,
stock_code varchar(20),
stock_name varchar(100),
stock_num int,
median_volume bigint,
shares_issued bigint,
free_float numeric(25,3),
ff_shares numeric(25,3),
median_liquidity numeric(25,3),
criteria numeric(25,3),
status bool
);

select * from dibots_v2.exchange_stock_liquidity_median 
where stock_code = '8869' order by year, month

alter table dibots_v2.exchange_stock_liquidity_median add constraint exchg_stock_liquidity_median_pkey primary key (year, month, stock_code);

-- get the median by ordering the volume, median = (# records / 2 ) = xth record is the median
select transaction_date, stock_code, stock_name_short, volume_traded_market_transaction, value_traded_market_transaction
from dibots_v2.exchange_daily_transaction where stock_code = '8869' and transaction_date between '2015-01-01' and '2015-01-31'
order by volume_traded_market_transaction

select extract(month from transaction_date), extract(year from transaction_date) from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-21'

-- get the median with sql function
select stock_code, stock_name_short, percentile_disc(0.5) within group (order by volume_traded_market_transaction) 
from dibots_v2.exchange_daily_transaction 
where stock_code = '8869' and transaction_date between '2015-01-01' and '2015-01-31'
group by stock_code, stock_name_short


select extract(month from transaction_date), extract(year from transaction_date), stock_code, stock_name_short, percentile_disc(0.5) within group (order by volume_traded_market_transaction) 
from dibots_v2.exchange_daily_transaction 
group by stock_code, stock_name_short, extract(month from transaction_date), extract(year from transaction_date)

-- insert the values
insert into dibots_v2.exchange_stock_liquidity_median (year, month, min_trading_date, max_trading_date, stock_code, stock_num, median_volume)
select extract(year from transaction_date), extract(month from transaction_date), min(transaction_date), max(transaction_date), 
stock_code, stock_num, percentile_disc(0.5) within group (order by volume_traded_market_transaction) 
from dibots_v2.exchange_daily_transaction 
where extract(year from transaction_date) >= ? and
extract(month from transaction_date) >= ? and
security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY')
group by stock_code, extract(year from transaction_date), extract(month from transaction_date);


-- update the stock_name separately from the insert because some stock name changes clashing the group by statement in the insert
update dibots_v2.exchange_stock_liquidity_median a
set
stock_name = tmp.stock_name_short
from (select a.stock_code, a.stock_name_short from dibots_v2.exchange_daily_transaction a,
(select stock_code, max(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
group by stock_code) b
where a.stock_code = b.stock_code and a.transaction_date = b.trans_date) tmp
where a.stock_code = tmp.stock_code;

-- shares_issued = shares_outstanding in daily_transaction of the latest date
update dibots_v2.exchange_stock_liquidity_median a
set
shares_issued = b.shares_outstanding
from dibots_v2.exchange_daily_transaction b
where a.max_trading_date = b.transaction_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_stock_liquidity_median a
set
free_float = b.free_float,
criteria = 0.04
from dibots_v2.company_free_float b
where a.stock_code = b.stock_code and year = (select max(year) from dibots_v2.exchange_stock_liquidity_median) 
and month = (select max(month) from dibots_v2.exchange_stock_liquidity_median where year = (select max(year) from dibots_v2.exchange_stock_liquidity_median))
and b.free_float > 0 and a.free_float is null;

-- free float, default 100, criteria default 0.05
update dibots_v2.exchange_stock_liquidity_median a
set
free_float = 100,
criteria = 0.04
where free_float is null;

-- ff_shares = shares_issued * free_float / 100
update dibots_v2.exchange_stock_liquidity_median a
set
ff_shares = shares_issued::numeric(25,2) * free_float / 100
where a.ff_shares is null;

-- median_liquidity = median_volume / ff_shares
update dibots_v2.exchange_stock_liquidity_median a
set
median_liquidity = case when ff_shares <> 0 then median_volume::numeric(25,2) / ff_shares * 100
				when ff_shares = 0 then 0 end
where median_liquidity is null;
			
-- status
update dibots_v2.exchange_stock_liquidity_median a
set
status = case when median_liquidity >= criteria then true 
		    when median_liquidity < criteria then false end
where a.status is null;

--============================
-- company_free_float table
--============================
-- A table to get the direct pct of shares from equity_security_owner. 100 - the result to get the free float

create table dibots_v2.company_free_float (
company_id uuid primary key,
stock_code varchar(10),
total_pct_shares numeric(25,2),
free_float numeric(25,2)
);

truncate dibots_v2.company_free_float;
insert into dibots_v2.company_free_float
select a.company_id, c.stock_code, sum(a.pct_of_shares), 100-sum(a.pct_of_shares) from dibots_v2.equity_security_owner a, dibots_v2.equity_security b, dibots_v2.exchange_stock_profile c
where a.wvb_equity_id = b.wvb_equity_id and b.sec_classif_code in ('ORD', 'UNT') and a.company_id = c.stock_identifier and c.eff_end_date is null and c.delisted_date is null and
a.eff_thru_date is null and a.handling_code in (1,2) and a.is_deleted = false and a.owner_id is not null
group by a.company_id, c.stock_code;

update dibots_v2.company_free_float
set free_float = 0
where free_float < 0;

select * from dibots_v2.company_free_float;
