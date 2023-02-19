select * from dibots_v2.exchange_demography

select stock_code, stock_name_short, stock_name_long, sum(market_capitalisation) from dibots_v2.exchange_daily_transaction where fbm100_flag = true
and transaction_date between '2020-01-01' and '2020-10-09'
group by stock_code, stock_name_short, stock_name_long
order by sum(market_capitalisation) desc

drop table tmp_fbm100_top;
create table tmp_fbm100_top (
stock_code varchar(100),
stock_name_short varchar(100),
market_cap numeric(25,3),
local_inst numeric(25,3),
local_retail numeric(25,3),
local_nominees numeric(25,3),
foreign_val numeric(25,3),
ivt_val numeric(25,3),
pdt_val numeric(25,3),
total numeric(25,3)
);

select * from tmp_fbm100_top

insert into tmp_fbm100_top (stock_code, stock_name_short, market_cap)
select stock_code, stock_name_short, sum(market_capitalisation) from dibots_v2.exchange_daily_transaction where
transaction_date between '2020-10-05' and '2020-10-09' and stock_code in (select stock_code from dibots_v2.exchange_daily_transaction where fbm100_flag is true and transaction_date = '2020-10-09')
group by stock_code, stock_name_short
order by sum(market_capitalisation) desc

update tmp_fbm100_top a
set
local_inst = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and locality = 'LOCAL' and group_type = 'INSTITUTIONAL'
group by stock_code) res 
where a.stock_code = res.stock_code

update tmp_fbm100_top a
set
local_retail = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and locality = 'LOCAL' and group_type = 'RETAIL'
group by stock_code) res 
where a.stock_code = res.stock_code


update tmp_fbm100_top a
set
local_nominees = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and locality = 'LOCAL' and group_type = 'NOMINEES'
group by stock_code) res 
where a.stock_code = res.stock_code

update tmp_fbm100_top a
set
foreign_val = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and locality = 'FOREIGN'
group by stock_code) res 
where a.stock_code = res.stock_code

update tmp_fbm100_top a
set
ivt_val = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and group_type = 'IVT'
group by stock_code) res 
where a.stock_code = res.stock_code

update tmp_fbm100_top a
set
pdt_val = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' and group_type = 'PDT'
group by stock_code) res 
where a.stock_code = res.stock_code


update tmp_fbm100_top a
set
total = res.total
from (
select stock_code, sum(net_value) as total from dibots_v2.exchange_demography_stock_broker
where trading_date between '2020-10-05' and '2020-10-09' 
group by stock_code) res 
where a.stock_code = res.stock_code


select * from tmp_fbm100_top where
(local_inst + local_retail + local_nominees + foreign_val + ivt_val + pdt_val) <> total

select * from tmp_fbm100_top order by market_cap desc

DROP TABLE tmp_agg_net;
create table tmp_agg_net (
month int,
year int,
local_inst numeric(25,3),
local_retail numeric(25,3),
local_nominees numeric(25,3),
foreign_val numeric(25,3),
ivt numeric(25,3),
pdt numeric(25,3)
);

select * from tmp_agg_net

insert into tmp_agg_net (month, year) select month, year from dibots_v2.broker_rank_month where year = 2019 and participant_code = 73

update tmp_agg_net agg
set
local_inst = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and  a.locality = 'LOCAL' and a.group_type = 'INSTITUTIONAL' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;

update tmp_agg_net agg
set
local_retail = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and a.locality = 'LOCAL' and a.group_type = 'RETAIL' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;

update tmp_agg_net agg
set
local_nominees = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and a.locality = 'LOCAL' and a.group_type = 'NOMINEES' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;

update tmp_agg_net agg
set
foreign_val = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and a.locality = 'FOREIGN' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;

update tmp_agg_net agg
set
ivt = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and a.group_type = 'IVT' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;

update tmp_agg_net agg
set
pdt = res.net
from
(
select b.year, b.month, sum(net_value) as net from dibots_v2.exchange_demography_stock_broker a, tmp_agg_net b
where a.sector = 'UTILITIES' and a.group_type = 'PDT' and extract(year from a.trading_date) = b.year and extract(month from a.trading_date) = b.month
group by b.year, b.month) res
where agg.year = res.year and agg.month = res.month;


select * from tmp_agg_net 
order by year asc, month asc

select * from dibots_v2.exchange_demography_stock_broker where sector LIKE 'UTILITIES%'

select distinct sector from dibots_v2.exchange_daily_transaction where transaction_date = '2020-10-09'

-- GLIC insider moves
select c.stock_code, b.stock_name, a.effective_date , a.dealer_name, sum(a.nbr_of_shares_acquired ) shares_acquired, sum(a.nbr_of_shares_disposed) shares_disposed
from dibots_v2.wvb_dir_dealing a, dibots_v2.exchange_stock_profile c, dibots_v2.ref_demography_stock b
where a.company_id = c.stock_identifier and c.stock_code = b.stock_code and b.trading_date = '2022-04-13' and b.sector = 'PLANTATION'
and a.eff_released_date >= '2022-03-01' and a.dealer_id in ('747ebe8a-cd65-4225-ada4-868e03406f94', 'f4cdb76b-0b1d-419d-b9a7-033f4b5b13ac', 'ad8f7362-c09d-458c-aa3b-5025380cc637', '744f8f26-130e-4f27-8527-d27552acb52c','c1af2883-f6fb-4217-9872-7e51f53aa88a', '8dcaf88b-7fc1-45b9-8915-2fc06da869e3')
group by c.stock_code, b.stock_name, a.dealer_name, a.effective_date 

