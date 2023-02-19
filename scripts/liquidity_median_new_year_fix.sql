-- EXCHANGE_STOCK_LIQUIDITY_MEDIAN manual intervention on new year

select * from dibots_v2.exchange_stock_liquidity_median where year = 2022 and month = 1;

insert into dibots_v2.exchange_stock_liquidity_median (year, month, min_trading_date, max_trading_date, stock_code, stock_num, median_volume)
select extract(year from transaction_date), extract(month from transaction_date), min(transaction_date), max(transaction_date), 
stock_code, stock_num, percentile_disc(0.5) within group (order by volume_traded_market_transaction) 
from dibots_v2.exchange_daily_transaction 
where extract(year from transaction_date) >= 2022 and
extract(month from transaction_date) >= 1 and
security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY')
group by stock_code, stock_num, extract(year from transaction_date), extract(month from transaction_date);

-- stock_name
update dibots_v2.exchange_stock_liquidity_median a
set
stock_name = tmp.stock_name_short
from (select a.stock_code, a.stock_name_short from dibots_v2.exchange_daily_transaction a,
(select stock_code, max(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction
group by stock_code) b
where a.stock_code = b.stock_code and a.transaction_date = b.trans_date) tmp
where a.stock_code = tmp.stock_code and a.stock_name is null;

-- free_float from dibots_v2.company_free_float
update dibots_v2.exchange_stock_liquidity_median a
set
free_float = b.free_float,
criteria = 0.04
from dibots_v2.company_free_float b
where a.stock_code = b.stock_code
and b.free_float > 0 and a.free_float is null;

-- shares_issued = shares_outstanding in daily_transaction of the latest date
update dibots_v2.exchange_stock_liquidity_median a
set
shares_issued = b.shares_outstanding
from dibots_v2.exchange_daily_transaction b
where a.max_trading_date = b.transaction_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_stock_liquidity_median a
set
free_float = 100,
criteria = 0.04
where a.free_float is null;

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