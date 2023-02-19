set schema 'dibots_v2'

select max(transaction_date) from exchange_daily_transaction

-- Materialized view of exchange_daily_transaction
-- to optimize the calculation of top gain loss
DROP MATERIALIZED VIEW mv_exchange_gnls;

CREATE MATERIALIZED VIEW dibots_v2.mv_exchange_gnls as
select 
  row_number() over () as id, foo.month_start_day, foo.stock_code, foo.stock_num,
  foo.adj_price_changed,
  (select adj_lacp from dibots_v2.exchange_daily_transaction 
  where stock_code = foo.stock_code and transaction_date >= foo.month_start_day limit 1) as adj_lacp,
  (select adj_closing from dibots_v2.exchange_daily_transaction 
  where stock_code = foo.stock_code and transaction_date >= foo.month_start_day limit 1) as adj_closing
from (
  select 
    stock_code, stock_num,
    date_trunc('month', transaction_date)::date as month_start_day,
    sum(adj_price_changed) as adj_price_changed
  from 
    dibots_v2.exchange_daily_transaction
  group by 
    stock_code, stock_num, date_trunc('month', transaction_date)
) as foo

--
-- Create the indexes for materialized view
--
CREATE UNIQUE INDEX mv_exchange_gnls_uniq ON dibots_v2.mv_exchange_gnls (month_start_day, stock_code);
CREATE UNIQUE INDEX mv_exchange_gnls_stock_uniq ON dibots_v2.mv_exchange_gnls (month_start_day, stock_num);


select * from mv_exchange_gnls where month_start_day = '2021-02-01' and stock_code = '3182'

select max(transaction_date) from exchange_daily_transaction

select * from exchange_daily_transaction where stock_code = '0041PA' and transaction_date between '2020-07-01' and '2020-12-18' order by transaction_date;

select * from mv_exchange_gnls where stock_code = '0041PA' order by month_start_day;

--
-- Refresh materialized view after getting the latest exchange data
--
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_exchange_gnls

--
-- Verify the materialized view
--
select stock_code, adj_price_changed
from mv_exchange_gnls
where month_start_day >= '2015-01-01' and month_start_day < '2016-01-01'



select * from dibots_v2.get_gnls('2019-12-15', '2020-01-01', '2020-05-01', '2020-06-01', '2020-06-15') order by adj_price_changed desc

select stock_code, stock_name_short, sum(adj_price_changed) from dibots_v2.exchange_daily_transaction where transaction_date between '2019-12-15' and '2020-06-15'
group by stock_code, stock_name_short
order by sum(adj_price_changed) desc

-- a function to get all the required data to calculate top gain loss
drop function get_gnls;

-- the schema name for each of the table in the function need to explicitly specified
CREATE OR REPLACE FUNCTION get_gnls(start_date varchar(255), begin_month_start varchar(255), end_month_start varchar(255), end_start_date varchar(255), end_end_date varchar(255))
 RETURNS TABLE(stock_code varchar(255), adj_price_changed numeric)
 LANGUAGE sql
AS $function$
  select stock_code, sum(tmp)
  from
  (
  select stock_code, sum(adj_price_changed) as tmp
  from dibots_v2.mv_exchange_gnls
  WHERE month_start_day >= to_date($2, 'YYYY/MM/DD') and month_start_day <= to_date($3, 'YYYY/MM/DD')
  group by stock_code
  union
  select stock_code, sum(adj_price_changed) as tmp
  from dibots_v2.exchange_daily_transaction
  where (transaction_date >= to_date($1, 'YYYY/MM/DD') and transaction_date < to_date($2, 'YYYY/MM/DD'))
  group by stock_code
  union
  select stock_code, sum(adj_price_changed) as tmp
  from dibots_v2.exchange_daily_transaction 
  where (transaction_date >= to_date($4, 'YYYY/MM/DD') and transaction_date <= to_date($5, 'YYYY/MM/DD'))
  group by stock_code) a
  group by stock_code
$function$;

select * from get_gnls('2020-06-10', '2020-07-01', '2020-08-01', '2020-09-01', '2020-09-30') 

-- verification

-- verification of gain loss 2020-03-01 and 2020-06-30
-- checked with API, correct
select a.stock_code, adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, sum(adj_price_changed) as adj_price_changed from mv_exchange_gnls
where month_start_day between '2020-03-01' and '2020-06-30' 
group by stock_code) a,
(select stock_code, adj_lacp, adj_closing from exchange_daily_transaction where transaction_date = '2020-03-02') b
where a.stock_code = b.stock_code
order by adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) desc

-- The old API way
select a.stock_code, a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, sum(adj_price_changed) as adj_price_changed
from exchange_daily_transaction where transaction_date between '2020-03-01' and '2020-06-30'
group by stock_code) a,
(select stock_code, adj_lacp, adj_closing 
from exchange_daily_transaction where transaction_date = '2020-03-02') b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) desc

select * from exchange_daily_transaction where transaction_date = '2020-03-02' and stock_code = '710678'

-- verification of gain loss 2020-06-10 and 2020-09-30
-- tallied
select a.stock_code, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, adj_price_changed from get_gnls('2020-06-10', '2020-07-01', '2020-08-01', '2020-09-01', '2020-09-30') ) a,
(select stock_code, adj_lacp, adj_closing from exchange_daily_transaction where transaction_date = '2020-06-10') b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) desc

-- the old API way
select a.stock_code, a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, sum(adj_price_changed) as adj_price_changed
from exchange_daily_transaction where transaction_date between '2020-06-10' and '2020-09-30'
group by stock_code) a,
(select stock_code, adj_lacp, adj_closing 
from exchange_daily_transaction where transaction_date = '2020-06-10') b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) desc


-- verification of gain loss 2019-12-15 to 2020-06-15
select a.stock_code, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, adj_price_changed from get_gnls('2019-12-15', '2020-01-01', '2020-05-01', '2020-06-01', '2020-06-15')) a,
(select stock_code, adj_lacp, adj_closing from exchange_daily_transaction where transaction_date = '2019-12-16') b
where a.stock_code = b.stock_code 
order by a.adj_price_changed / coalesce(nullif(b.adj_lacp,0), nullif(b.adj_closing,0), 1)  desc

-- the api way
select a.stock_code, a.stock_name_short, a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) as gain
from
(select stock_code, stock_name_short, sum(adj_price_changed) as adj_price_changed
from exchange_daily_transaction where transaction_date between '2019-12-15' and '2020-06-15'
group by stock_code, stock_name_short) a,
(select stock_code, stock_name_short, adj_lacp, adj_closing 
from exchange_daily_transaction where transaction_date = '2019-12-16') b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(adj_lacp,0), nullif(b.adj_closing,0), 1) desc



--===========================
-- new method in API
--===========================

--dibots.get_gnls(param1, param2, param3, param4, param5)
-- param1 = start_date
-- param2 = if start_date is 01 then start_date else start_date + 1 month 01
-- param3 = end_date - 1 month, 01
-- param4 = end_date 01
-- param5 = end_date

-- scneario 1: 2019-12-15 to 2020-06-15 (both sides not within bound)
select stock_code, adj_price_changed from get_gnls('2019-12-15', '2020-01-01', '2020-05-01', '2020-06-01', '2020-06-15')
where stock_code in ('1818', '8869', '6012')

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2019-12-15' and '2020-06-15'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short

-- scenario 2: 2020-01-01 to 2020-06-30 (both sides within bound)
select stock_code, adj_price_changed from get_gnls('2020-01-01', '2020-01-01', '2020-05-01', '2020-06-01', '2020-06-30')
where stock_code in ('1818', '8869', '6012')

select stock_code, sum(adj_price_changed) from mv_exchange_gnls where month_start_day between '2020-01-01' and '2020-06-30' and
stock_code in ('1818', '8869', '6012')
group by stock_code

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2020-01-01' and '2020-06-30'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short


-- scenario 3: 2020-02-12 to 2020-09-30 (left side exceeds bound)
select stock_code, sum(adj_price_changed) as adj_price_changed from get_gnls('2020-02-12', '2020-03-01', '2020-08-01', '2020-09-01', '2020-09-30')
where stock_code in ('1818', '8869', '6012')
group by stock_code

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2020-02-12' and '2020-09-30'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short

-- scenario 4: 2020-03-01 to 2020-10-15 (right side exceeds bound)
select stock_code, adj_price_changed from get_gnls('2020-03-01', '2020-03-01', '2020-09-01', '2020-10-01', '2020-10-15')
where stock_code in ('1818', '8869', '6012')

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2020-03-01' and '2020-10-15'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short

-- scenario 5: 2020-03-01 to 2020-11-01 
select stock_code, adj_price_changed from get_gnls('2020-03-01', '2020-03-01', '2020-10-01', '2020-11-01', '2020-11-01')
where stock_code in ('1818', '8869', '6012')

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2020-03-01' and '2020-11-01'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short


-- scenario 5: 2020-03-01 to 2020-11-01 
select stock_code, adj_price_changed from get_gnls('2020-03-01', '2020-03-01', '2020-10-01', '2020-11-01', '2020-11-01')
where stock_code in ('1818', '8869', '6012')

select stock_code, stock_name_short, sum(adj_price_changed) from exchange_daily_transaction where transaction_date between '2020-03-01' and '2020-11-01'
and stock_code in ('1818', '8869', '6012')
group by stock_code, stock_name_short

