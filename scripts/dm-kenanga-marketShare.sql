-- KENANGA data mining for overall market value and kenanga traded value for YTD 2021, daily

select trading_date, sum(total_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date >= '2021-01-01'
group by trading_date order by trading_date asc

select trading_date, sum(total_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date >= '2021-01-01' and participant_code = 73
group by trading_date order by trading_date asc;

-- value
select a.trading_date, a.total_market_value::numeric(25,2), b.kenanga_traded_value::numeric(25,2), (b.kenanga_traded_value/a.total_market_value*100)::numeric(25,2) from
(select trading_date, sum(total_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(total_value)/1000000 as kenanga_traded_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- volume
select a.trading_date, a.total_market_volume::numeric(25,2), b.kenanga_traded_volume::numeric(25,2), (b.kenanga_traded_volume/a.total_market_volume*100)::numeric(25,2) from
(select trading_date, sum(total_volume)/1000000 as total_market_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(total_volume)/1000000 as kenanga_traded_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- retail value
select a.trading_date, a.total_market_value::numeric(25,2), b.kenanga_traded_value::numeric(25,2), (b.kenanga_traded_value/a.total_market_value*100)::numeric(25,2) from
(select trading_date, sum(total_retail_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(total_retail_value)/1000000 as kenanga_traded_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- retail volume
select a.trading_date, a.total_market_volume::numeric(25,2), b.kenanga_traded_volume::numeric(25,2), (b.kenanga_traded_volume/a.total_market_volume*100)::numeric(25,2) from
(select trading_date, sum(total_retail_volume)/1000000 as total_market_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(total_retail_volume)/1000000 as kenanga_traded_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- local_nominees value
select a.trading_date, a.total_market_value::numeric(25,2), b.kenanga_traded_value::numeric(25,2), (b.kenanga_traded_value/a.total_market_value*100)::numeric(25,2) from
(select trading_date, sum(local_nominees_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(local_nominees_value)/1000000 as kenanga_traded_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- local_nominees volume
select a.trading_date, a.total_market_volume::numeric(25,2), b.kenanga_traded_volume::numeric(25,2), (b.kenanga_traded_volume/a.total_market_volume*100)::numeric(25,2) from
(select trading_date, sum(local_nominees_volume)/1000000 as total_market_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(local_nominees_volume)/1000000 as kenanga_traded_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- foreign_nominees value
select a.trading_date, a.total_market_value::numeric(25,2), b.kenanga_traded_value::numeric(25,2), (b.kenanga_traded_value/a.total_market_value*100)::numeric(25,2) from
(select trading_date, sum(foreign_nominees_value)/1000000 as total_market_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(foreign_nominees_value)/1000000 as kenanga_traded_value from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

-- foreign_nominees volume
select a.trading_date, a.total_market_volume::numeric(25,2), b.kenanga_traded_volume::numeric(25,2), (b.kenanga_traded_volume/a.total_market_volume*100)::numeric(25,2) from
(select trading_date, sum(foreign_nominees_volume)/1000000 as total_market_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19'
group by trading_date order by trading_date asc) a,
(select trading_date, sum(foreign_nominees_volume)/1000000 as kenanga_traded_volume from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2021-04-19' and participant_code = 73
group by trading_date order by trading_date asc) b
where a.trading_date = b.trading_date
order by trading_date asc

select * from dibots_v2.broker_profile 