--drop table bursa_stock_info;
create table bursa_stock_info 
(
id bigserial primary key, 
year int, 
fye_date date,
closest_trading_date date,
dbt_entity_id uuid,
wvb_hdr_id bigint,
stock_code varchar(10),
stock_name VARCHAR(50), 
company_name varchar(255),
board VARCHAR(100), 
sector VARCHAR(100), 
pat NUMERIC(25,2), 
shares_outstanding NUMERIC(25,2), 
dividend NUMERIC(25,2), 
earning_per_share NUMERIC(25,2), 
dividend_per_share NUMERIC(25,2), 
roa NUMERIC(25,2), 
roe NUMERIC(25,2), 
shares_in_issued NUMERIC(25,2), 
market_cap NUMERIC(25,2), 
latest_shares_in_issued NUMERIC(25,2), 
latest_market_cap NUMERIC(25,2) 
); 


select * from bursa_stock_info

-- insert the stock information into the table with different year
insert into bursa_stock_info(year, dbt_entity_id, stock_code, stock_name, company_name, board, sector)
select 2020, a.stock_identifier, a.stock_code, a.short_name, a.company_name, a.board, a.sector
from dibots_v2.exchange_stock_profile a
where (a.eff_end_date between '2020-01-01' and '2020-12-31' or a.eff_end_date is null) and stock_identifier is not null;

select count(*) from bursa_stock_info where year = 2020

-- latest_market_cap
update bursa_stock_info a
set
latest_market_cap = tmp.market_capitalisation
from (
select a.stock_code, a.market_capitalisation from dibots_v2.exchange_daily_transaction a, (
select stock_code, max(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction 
group by stock_code) b
where a.stock_code = b.stock_code and a.transaction_date = b.trans_date) tmp
where a.stock_code = tmp.stock_code


-- latest_shares_in_issued
update bursa_stock_info a
set
latest_shares_in_issued = tmp.shares_outstanding
from (
select a.stock_code, a.shares_outstanding from dibots_v2.exchange_daily_transaction a, (
select stock_code, max(transaction_date) as trans_date from dibots_v2.exchange_daily_transaction 
group by stock_code) b
where a.stock_code = b.stock_code and a.transaction_date = b.trans_date) tmp
where a.stock_code = tmp.stock_code


-- closest trading date to the fye

update bursa_stock_info a
set
closest_trading_date = tmp.trans_date
from (
select b.stock_code, max(b.transaction_date) as trans_date from bursa_stock_info a, dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and year = 2020 and b.transaction_date <= a.fye_date
group by b.stock_code) tmp
where a.stock_code = tmp.stock_code and a.year = 2020


select fye_date, stock_code, closest_trading_date from bursa_stock_info where fye_date is not null

-- market_cap for FYE
select a.stock_code, b.market_capitalisation 
from bursa_stock_info a, dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and a.closest_trading_date = b.transaction_date

update bursa_stock_info a
set
market_cap = b.market_capitalisation
from dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and a.closest_trading_date = b.transaction_date


-- shares_in_issued
update bursa_stock_info a
set
shares_in_issued = b.shares_outstanding
from dibots_v2.exchange_daily_transaction b
where a.stock_code = b.stock_code and a.closest_trading_date = b.transaction_date



select * from bursa_stock_info where shares_outstanding is not null
