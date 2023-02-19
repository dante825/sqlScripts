--=======================
-- exchange_shareholdings
--========================
-- derived from exchange_holdings_by_investor table with exchange_demography data (OMTDBT)

--drop table dibots_v2.exchange_shareholdings;
create table dibots_v2.exchange_shareholdings (
trading_date date,
week_count text,
stock_code text,
stock_name text,
stock_num int,
board text,
sector text,
closing_price numeric(25,3),
snapshot_date date,
total_shares bigint,
local_inst_pct numeric(25,8),
local_inst_chg numeric(25,8),
local_inst_vol numeric(25,8),
local_inst_val numeric(25,8),
foreign_inst_pct numeric(25,8),
foreign_inst_chg numeric(25,8),
foreign_inst_vol numeric(25,8),
foreign_inst_val numeric(25,8),
local_retail_pct numeric(25,8),
local_retail_chg numeric(25,8),
local_retail_vol numeric(25,8),
local_retail_val numeric(25,8),
foreign_retail_pct numeric(25,8),
foreign_retail_chg numeric(25,8),
foreign_retail_vol numeric(25,8),
foreign_retail_val numeric(25,8),
local_nominees_pct numeric(25,8),
local_nominees_chg numeric(25,8),
local_nominees_vol numeric(25,8),
local_nominees_val numeric(25,8),
foreign_nominees_pct numeric(25,8),
foreign_nominees_chg numeric(25,8),
foreign_nominees_vol numeric(25,8),
foreign_nominees_val numeric(25,8),
foreign_pct numeric(25,8),
foreign_chg numeric(25,8),
foreign_vol numeric(25,8),
foreign_val numeric(25,8)
);

alter table dibots_v2.exchange_shareholdings add constraint exchg_shrdlgs_pkey primary key (trading_date, stock_code);

create index exchag_shrdlgs_week_cnt_idx on dibots_v2.exchange_shareholdings (week_count);

update dibots_v2.exchange_shareholdings
set week_count = to_char(trading_date, 'IYYY-IW');

update dibots_v2.exchange_shareholdings a
set
closing_price = b.closing_price
from dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
local_inst_vol = coalesce(local_inst_pct,0) * total_shares / 100,
foreign_inst_vol = coalesce(foreign_inst_pct,0) * total_shares / 100,
local_retail_vol = coalesce(local_retail_pct,0) * total_shares / 100,
foreign_retail_vol = coalesce(foreign_retail_pct,0) * total_shares / 100,
local_nominees_vol = coalesce(local_nominees_pct,0) * total_shares / 100,
foreign_nominees_vol = coalesce(foreign_nominees_pct,0) * total_shares / 100,
foreign_vol = coalesce(foreign_pct,0) * total_shares / 100;

select trading_date, stock_code, total_shares, local_inst_vol + foreign_inst_vol + local_retail_vol + foreign_retail_vol + local_nominees_vol + foreign_nominees_vol 
from dibots_v2.exchange_shareholdings
where local_inst_vol <> 0 and local_inst_vol + foreign_inst_vol + local_retail_vol + foreign_retail_vol + local_nominees_vol + foreign_nominees_vol < total_shares - 2

update dibots_v2.exchange_shareholdings a
set
local_inst_val = local_inst_vol * closing_price,
foreign_inst_val = foreign_inst_vol * closing_price,
local_retail_val = local_retail_vol * closing_price,
foreign_retail_val = foreign_retail_vol * closing_price,
local_nominees_val = local_nominees_vol * closing_price,
foreign_nominees_val = foreign_nominees_vol * closing_price,
foreign_val = foreign_vol * closing_price;

select trading_date, stock_code, total_shares * closing_price as market_cap, local_inst_val + foreign_inst_val + local_retail_val + foreign_retail_val + local_nominees_val + foreign_nominees_val
from dibots_v2.exchange_shareholdings 
where total_shares * closing_price < local_inst_val + foreign_inst_val + local_retail_val + foreign_retail_val + local_nominees_val + foreign_nominees_val


-- INITIATING the table with data from dibots_v2.exchange_holdings_by_investor (using SHARES_OUTSTANDING as the total shares
insert into dibots_v2.exchange_shareholdings (trading_date, stock_code, stock_name, board, sector, total_shares)
select distinct b.transaction_date, b.stock_code, b.stock_name_short, b.board, b.sector, b.shares_outstanding
from dibots_v2.exchange_holdings_by_investor a, dibots_v2.exchange_daily_transaction b
where a.as_of_date = b.transaction_date and a.stock_code = b.stock_code;

--=================
-- INITIATING the table with data from dibots_v2.exchange_holdings_by_investor (using SUM OF SHARES as the total shares
insert into dibots_v2.exchange_shareholdings (trading_date, stock_code, stock_name, board, sector)
select distinct b.transaction_date, b.stock_code, b.stock_name_short, b.board, b.sector
from dibots_v2.exchange_holdings_by_investor a, dibots_v2.exchange_daily_transaction b
where a.as_of_date = b.transaction_date and a.stock_code = b.stock_code;

-- set the total_shares based on the SUM of SECURITIES_TOTAL_SHARES
update dibots_v2.exchange_shareholdings a
set
total_shares = b.total
from 
(select stock_code, sum(securities_total_shares) as total from dibots_v2.exchange_holdings_by_investor 
group by stock_code) b
where a.stock_code = b.stock_code;

-- set the total_shares back to SHARES_OUTSTANDING (optional)
update dibots_v2.exchange_shareholdings a
set
total_shares = b.shares_outstanding
from dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code;
--=======================

select * from dibots_v2.exchange_shareholdings order by trading_date desc;

update dibots_v2.exchange_shareholdings a
set
local_inst_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
foreign_inst_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'FOREIGN' and group_type = 'INSTITUTIONAL'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
local_retail_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'LOCAL' and group_type = 'RETAIL'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
foreign_retail_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'FOREIGN' and group_type = 'RETAIL'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
local_nominees_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'LOCAL' and group_type = 'NOMINEES'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings a
set
foreign_nominees_pct = cast(b.total_shares as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100
from
(select as_of_date, stock_code, sum(securities_total_shares) as total_shares from dibots_v2.exchange_holdings_by_investor
where locality = 'FOREIGN' and group_type = 'NOMINEES'
group by as_of_date, stock_code) b
where a.trading_date = b.as_of_date and a.stock_code = b.stock_code;

update dibots_v2.exchange_shareholdings
set
local_inst_chg = 0,
foreign_inst_chg = 0,
local_retail_chg = 0,
foreign_retail_chg = 0,
local_nominees_chg = 0,
foreign_nominees_chg = 0
where trading_date = '2020-03-31';


-- verification

-- 62
select a.trading_date, a.stock_code, coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0)
from dibots_v2.exchange_shareholdings a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY') and a.trading_date = '2020-03-31'
and coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0) < 99

-- 2
select a.trading_date, a.stock_code, coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0)
from dibots_v2.exchange_shareholdings a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY') and a.trading_date = '2020-03-31'
and coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0) > 101

select * from dibots_v2.exchange_holdings_by_investor where stock_code = '7170'

select distinct group_type from dibots_v2.exchange_holdings_by_investor

--================================================================
-- EXPAND the table with data from dibots_v2.exchange_omtdbt_stock

-- INSERT the records

insert into dibots_v2.exchange_shareholdings (trading_date, stock_code, stock_name, board, sector, total_shares)
select transaction_date, stock_code, stock_name_short, board, sector, shares_outstanding
from dibots_v2.exchange_daily_transaction
where transaction_date > (select max(trading_date) from dibots_v2.exchange_shareholdings)
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_shareholdings where trading_date = '2020-03-31');

select * from dibots_v2.exchange_shareholdings where trading_date > '2020-03-31'

--delete from dibots_v2.exchange_shareholdings where trading_date > '2020-03-31'

-- PROCESS with a python script

select * from dibots_v2.exchange_omtdbt_stock;

select a.trading_date, a.stock_code, cast(coalesce(b.net_local_inst_vol,0) as numeric(25,2)) / cast(a.total_shares as numeric(25,2)) * 100, coalesce(b.net_foreign_inst_vol) / a.total_shares * 100,
coalesce(b.net_local_retail_vol,0) / a.total_shares * 100, coalesce(b.net_foreign_retail_vol,0) / a.total_shares * 100,
(coalesce(b.net_local_nominees_vol,0) + coalesce(b.net_ivt_vol,0) + coalesce(b.net_pdt_vol,0)) / a.total_shares * 100, coalesce(b.net_foreign_nominees_vol,0) / a.total_shares * 100
from dibots_v2.exchange_shareholdings a, dibots_v2.exchange_omtdbt_stock b
where a.trading_date = b.trading_date and a.stock_code = b.stock_code

-- verification after python scripts run

select * from dibots_v2.exchange_shareholdings where stock_code = '5819' order by trading_date asc;

select a.trading_date, a.stock_code, coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0)
from dibots_v2.exchange_shareholdings a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY')
and coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0) < 99

select a.trading_date, a.stock_code, coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0)
from dibots_v2.exchange_shareholdings a, dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code and b.security_type in ('LOCAL ORDINARY', 'REAL ESTATE INVESTMENT TRUSTS', 'STAPLED SECURITY')
and coalesce(local_inst_pct,0) + coalesce(foreign_inst_pct,0) + coalesce(local_retail_pct,0) + coalesce(foreign_retail_pct,0) + coalesce(local_nominees_pct,0) + coalesce(foreign_nominees_pct,0) > 101

--delete from dibots_v2.exchange_shareholdings where trading_date > '2020-03-31';

--================================
-- SHAREHOLDINGS BY INVESTOR TYPE
--================================

select * from dibots_v2.exchange_shareholdings where trading_date = '2021-08-20'

drop table if exists tmp_shareholdings;
create temp table tmp_shareholdings (
trading_date date,
stock_code text,
stock_name text,
total_shares bigint,
closing_price numeric(25,3),
market_cap numeric(25,3),
local_inst_vol numeric(25,3),
foreign_inst_vol numeric(25,3),
local_inst_val numeric(25,3),
foreign_inst_val numeric(25,3),
local_retail_vol numeric(25,3),
foreign_retail_vol numeric(25,3),
local_retail_val numeric(25,3),
foreign_retail_val numeric(25,3),
local_nominees_vol numeric(25,3),
foreign_nominees_vol numeric(25,3),
local_nominees_val numeric(25,3),
foreign_nominees_val numeric(25,3)
);

select * from tmp_shareholdings;

insert into tmp_shareholdings (trading_date, stock_code, stock_name, total_shares, local_inst_vol, foreign_inst_vol, local_retail_vol, foreign_retail_vol, local_nominees_vol, foreign_nominees_vol)
select trading_date, stock_code, stock_name, total_shares, (local_inst_pct*total_shares/100)::numeric(25,3) as local_inst, (foreign_inst_pct*total_shares/100)::numeric(25,3) as foreign_inst,
(local_retail_pct*total_shares/100)::numeric(25,3) as local_retail, (foreign_retail_pct*total_shares/100)::numeric(25,3) as foreign_retail, 
(local_nominees_pct*total_shares/100)::numeric(25,3) as local_nominees, (foreign_nominees_pct*total_shares/100)::numeric(25,3) as foreign_nominees
from dibots_v2.exchange_shareholdings where trading_date = '2021-08-20'


update tmp_shareholdings a
set
closing_price = b.closing_price,
market_cap = b.market_capitalisation
from dibots_v2.exchange_daily_transaction b
where a.trading_date = b.transaction_date and a.stock_code = b.stock_code;

select trading_date, stock_code, stock_name, total_shares * closing_price, market_cap from tmp_shareholdings where total_shares * closing_price <> market_cap;

update tmp_shareholdings 
set
local_inst_val = local_inst_vol * closing_price,
foreign_inst_val = foreign_inst_vol * closing_price,
local_retail_val = local_retail_vol * closing_price,
foreign_retail_val = foreign_retail_vol * closing_price,
local_nominees_val = local_nominees_vol * closing_price,
foreign_nominees_val = foreign_nominees_vol * closing_price;

-- final result
select sum(market_cap), sum(local_inst_val)/sum(market_cap)*100 as local_inst, sum(foreign_inst_val)/sum(market_cap)*100 as foreign_inst, 
sum(local_retail_val)/sum(market_cap)*100 as local_retail, sum(foreign_retail_val)/sum(market_cap)*100 as foreign_retail,
sum(local_nominees_val)/sum(market_cap)*100 as local_nominees, sum(foreign_nominees_val)/sum(market_cap)*100 as foreign_nominees
from tmp_shareholdings
where trading_date = '2021-03-30'



--=========================
-- FOREIGN_SHAREHOLDINGS
--=========================


create table staging.foreign_shareholdings (
stock_code text,
stock_name text,
comp_name text,
foreign_shareholdings_str text,
foreign_shareholding numeric(25,3),
snapshot_date date
);

select cast(regexp_replace(foreign_shareholdings_str, '%', '', 'g') as numeric(25,3)) from staging.foreign_shareholdings

update staging.foreign_shareholdings
set
foreign_shareholding = cast(regexp_replace(foreign_shareholdings_str, '%', '', 'g') as numeric(25,3))

select * from staging.foreign_shareholdings

update staging.foreign_shareholdings
set
snapshot_date = '2021-06-30';

-- a verification

select a.snapshot_date, b.trading_date, a.stock_code, b.stock_code, b.stock_name, a.foreign_shareholding, b.foreign_pct from staging.foreign_shareholdings a
left join dibots_v2.exchange_shareholdings b
on a.stock_code = b.stock_code and b.trading_date = a.snapshot_date

--delete from dibots_v2.exchange_shareholdings where trading_date > '2021-06-30'

select a.trading_date, a.stock_code, a.foreign_pct, b.foreign_shareholding, a.snapshot_date from dibots_v2.exchange_shareholdings a
join staging.foreign_shareholdings b
on a.stock_code = b.stock_code 
where a.trading_date = '2021-06-30'

update dibots_v2.exchange_shareholdings a
set
foreign_pct = b.foreign_shareholding,
snapshot_date = '2021-06-30'
from staging.foreign_shareholdings b
where a.stock_code = b.stock_code and a.trading_date = '2021-06-30';


select * from dibots_v2.exchange_shareholdings where trading_date = '2021-06-30' and snapshot_date = '2021-06-30'

select * from dibots_v2.exchange_shareholdings where trading_date > '2021-06-30'

vacuum (analyze) dibots_v2.exchange_shareholdings;

