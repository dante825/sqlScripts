-- top tain loss verification steps (using the materialized view)
-- 1. get a list of distinct stock_code from the date range
-- 2. use the function dibots_v2.get_gnls to get the sum of price change
-- 3. get the first trading day within the date range
-- 4. result from step 2 divide by adj_lacp of the result in step 3

-- func params
-- get_gnls(start_date varchar(255), begin_month_start varchar(255), end_month_start varchar(255), end_start_date varchar(255), end_end_date varchar(255))

select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18';

select * from dibots_v2.get_gnls('2020-07-01', '2020-07-01', '2020-11-01', '2020-12-01', '2020-12-18') where stock_code in (
select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')
order by adj_price_changed desc;

select * from dibots_v2.get_gnls('2020-07-01', '2020-07-01', '2020-11-01', '2020-12-01', '2020-12-18') where stock_code = '0041PA'

select * from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18' order by transaction_date limit 1;

select * from dibots_v2.exchange_daily_transaction where transaction_date = '2020-07-01'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')

select a.stock_code, a.adj_price_changed, b.adj_lacp, b.adj_closing, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) from
(select * from dibots_v2.get_gnls('2020-07-01', '2020-07-01', '2020-11-01', '2020-12-01', '2020-12-18') where stock_code in (
select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2020-07-01'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')) b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) desc



select sum(price_changed), sum(adj_price_changed) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18' and stock_code = '0041PA'

select * from dibots_v2.mv_exchange_gnls where stock_code = '0041PA' order by month_start_day

-- top tain loss verification steps (without using the materialized view)
-- 1. get a list of distinct stock_code from the date range
-- 2. get the sum of adj_price_changed
-- 3. get the first trading day within the date range
-- 4. result from step 2 divide by adj_lacp of the result in step 3

select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18';

select stock_code, sum(adj_price_changed) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')
group by stock_code

select * from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18' order by transaction_date limit 1;

select a.stock_code, b.stock_name_short, a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) from
(select stock_code, sum(adj_price_changed) as price_changed_sum from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2020-07-01' and '2020-12-18')
group by stock_code) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2020-07-01') b
where a.stock_code = b.stock_code
order by a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) desc


--=====================================
-- Gain loss on a single day on 1 stock
-- ====================================

select * from dibots_v2.exchange_daily_transaction where stock_code = '5099' and transaction_date = '2021-03-29'

--without view
select a.stock_code, a.stock_name_short, a.adj_price_changed / a.adj_lacp from dibots_v2.exchange_daily_transaction a where stock_code = '5099' and transaction_date = '2021-03-29'

-- with view
select * from dibots_v2.get_gnls('2021-03-29', '2021-04-01', '2021-02-01', '2021-03-01', '2021-03-29') where stock_code = '5099'
--view result is incorrect because it take the previous month into consideration

--==================================
-- gain loss on a few days period
--==================================

-- without view
select a.stock_code, b.stock_name_short, a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) from
(select stock_code, sum(adj_price_changed) as price_changed_sum from dibots_v2.exchange_daily_transaction where transaction_date between '2021-03-22' and '2021-03-29'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-03-22' and '2021-03-29')
group by stock_code) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-03-22') b
where a.stock_code = b.stock_code
order by a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) desc


-- with view
select a.stock_code, a.adj_price_changed, b.adj_lacp, b.adj_closing, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) from
(select * from dibots_v2.get_gnls('2021-03-22', '2021-04-01', '2021-02-01', '2021-03-01', '2021-03-29') where stock_code in (
select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-03-22' and '2021-03-29')) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-03-22'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-03-22' and '2021-03-29')) b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) desc
-- doesn't tally....view is inaccurate when the range is short, what's the ideal range for view?


--==================================
-- gain loss view verification on the range
--==================================

-- without view
select a.stock_code, b.stock_name_short, a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) from
(select stock_code, sum(adj_price_changed) as price_changed_sum from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-02-28'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-02-28')
group by stock_code) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-04') b
where a.stock_code = b.stock_code
order by a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) desc


-- with view
select a.stock_code, a.adj_price_changed, b.adj_lacp, b.adj_closing, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) from
(select * from dibots_v2.get_gnls('2021-01-01', '2021-01-01', '2021-01-01', '2021-02-01', '2021-02-28') where stock_code in (
select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-02-28')) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-04'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-02-28')) b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) desc

-- the results tally, view works fine in 2 month range


-- without view
select a.stock_code, b.stock_name_short, a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) from
(select stock_code, sum(adj_price_changed) as price_changed_sum from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-01-31'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-01-31')
group by stock_code) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-04') b
where a.stock_code = b.stock_code
order by a.price_changed_sum / coalesce(nullif(b.adj_lacp,0), 1) desc


-- with view
select a.stock_code, a.adj_price_changed, b.adj_lacp, b.adj_closing, a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) from
(select * from dibots_v2.get_gnls('2021-01-01', '2021-01-01', '2020-12-01', '2021-01-01', '2021-01-31') where stock_code in (
select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-01-31')) a, 
(select * from dibots_v2.exchange_daily_transaction where transaction_date = '2021-01-04'
and stock_code in (select distinct(stock_code) from dibots_v2.exchange_daily_transaction where transaction_date between '2021-01-01' and '2021-01-31')) b
where a.stock_code = b.stock_code
order by a.adj_price_changed / coalesce(nullif(b.adj_lacp,0),1) desc