-- CGS yearbook data mining

-- total value
select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(local_inst_value)::numeric(25,0) as local_inst, sum(local_retail_value)::numeric(25,0) as local_retail, sum(local_nominees_value)::numeric(25,0) as local_nominees, 
sum(foreign_value)::numeric(25,0) as foreign, sum(ivt_value)::numeric(25,0) as ivt, sum(pdt_value)::numeric(25,0) as pdt, sum(total_value)::numeric(25,0) as total
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2020-12-31'
group by extract(year from trading_date), extract(month from trading_date)

-- net value
select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2020-12-31'
group by extract(year from trading_date), extract(month from trading_date)

select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2018-01-01' and '2018-12-31'
group by extract(year from trading_date), extract(month from trading_date)

select sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'


-- age band
select age_band, sum(total_buysell_value)::numeric(25,0)
from dibots_v2.exchange_demography_stock_age_band where trading_date between '2018-01-01' and '2018-12-31'
group by age_band order by age_band

select age_band, sum(total_buysell_value)::numeric(25,0)
from dibots_v2.exchange_demography_stock_age_band where trading_date between '2019-01-01' and '2019-12-31'
group by age_band order by age_band

select age_band, sum(total_buysell_value)::numeric(25,0)
from dibots_v2.exchange_demography_stock_age_band where trading_date between '2020-01-01' and '2020-12-31'
group by age_band order by age_band

select age_band, sum(total_buysell_value)::numeric(25,0)
from dibots_v2.exchange_demography_stock_age_band where trading_date between '2020-12-01' and '2020-12-31'
group by age_band order by age_band


-- net value by sector
select sector, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31' and
sector not in ('TRADING/SERVICES','SPECIAL PURPOSE ACQUISITION COMPANY','BOND ISLAMIC','CLOSED END FUND', 'STRUCTURED WARRANTS', 'EXCHANGE TRADED FUND-BOND', 'EXCHANGE TRADED FUND-COMMODITY', 'EXCHANGE TRADED FUND-EQUITY', 'EXCHANGE TRADED FUND-L&I')
group by sector
order by sector

select sector, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2019-12-31' and
sector not in ('TRADING/SERVICES','SPECIAL PURPOSE ACQUISITION COMPANY','BOND ISLAMIC','CLOSED END FUND', 'STRUCTURED WARRANTS', 'EXCHANGE TRADED FUND-BOND', 'EXCHANGE TRADED FUND-COMMODITY', 'EXCHANGE TRADED FUND-EQUITY', 'EXCHANGE TRADED FUND-L&I')
group by sector
order by sector

select sector, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2018-01-01' and '2018-12-31' and
sector not in ('TRADING/SERVICES','SPECIAL PURPOSE ACQUISITION COMPANY','BOND ISLAMIC','CLOSED END FUND', 'STRUCTURED WARRANTS', 
'EXCHANGE TRADED FUND-BOND', 'EXCHANGE TRADED FUND-COMMODITY', 'EXCHANGE TRADED FUND-EQUITY', 'EXCHANGE TRADED FUND-L&I', 'HOTEL', 'INFRASTRUCTURE PROJECT COS.', 'LEAP', 'MINING')
group by sector
order by sector

--klci
select distinct(stock_code) from dibots_v2.exchange_demography_stock_broker_group where trading_date between '2019-01-01' and '2019-12-31' and klci_flag = true

select stock_code, stock_name, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31' and stock_code = '1015'
group by stock_code, stock_name

select stock_code, stock_name, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2019-12-31' and stock_code = '1015'
group by stock_code, stock_name

-- net value for glove stocks

select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2020-12-31' and stock_code = '7113'
group by extract(year from trading_date), extract(month from trading_date)
order by year, month

select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2020-12-31' and stock_code = '5168'
group by extract(year from trading_date), extract(month from trading_date)
order by year, month

select extract(year from trading_date) as year, extract(month from trading_date) as month,
sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_value)::numeric(25,0) as foreign, sum(net_ivt_value)::numeric(25,0) as ivt, sum(net_pdt_value)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2019-01-01' and '2020-12-31' and stock_code = '7106'
group by extract(year from trading_date), extract(month from trading_date)
order by year, month

-- top 20 net buy
--local_inst
select stock_code, stock_name, sum(coalesce(net_local_inst_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) desc limit 20;

--local_retail
select stock_code, stock_name, sum(coalesce(net_local_retail_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_retail_val,0)) desc limit 20;

--local_nominees
select stock_code, stock_name, sum(coalesce(net_local_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) desc limit 20;

--foreign
select stock_code, stock_name, sum(coalesce(net_foreign_value,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_value,0)) desc limit 20;

--proprietary
select stock_code, stock_name, sum(coalesce(net_prop_value,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_prop_value,0)) desc limit 20;

-- top 20 net sell
--local_inst
select stock_code, stock_name, sum(coalesce(net_local_inst_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) asc limit 20;

--local_retail
select stock_code, stock_name, sum(coalesce(net_local_retail_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_retail_val,0)) asc limit 20;

--local_nominees
select stock_code, stock_name, sum(coalesce(net_local_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) asc limit 20;

--foreign
select stock_code, stock_name, sum(coalesce(net_foreign_value,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_value,0)) asc limit 20;

--proprietary
select stock_code, stock_name, sum(coalesce(net_prop_value,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_broker_group
where trading_date between '2020-01-01' and '2020-12-31'
group by stock_code, stock_name
order by sum(coalesce(net_prop_value,0)) asc limit 20;


-- share buy back
select b.stock_code, b.short_name, sum(coalesce(a.total_amount_paid,a.value_acquired,0))::numeric(25,0) as total_amount_paid
from dibots_v2.wvb_dir_dealing a, dibots_v2.exchange_stock_profile b
where a.company_id = b.stock_identifier and b.delisted_date is null and b.eff_end_date is null and exchange = 'BURSA' and
a.company_id = a.dealer_id and a.eff_released_date between '2020-01-01' and '2020-12-31' --and (a.total_treasure_share is not null or a.total_amount_paid is not null) and a.nbr_of_shares_acquired is not null
group by b.stock_code, b.short_name
order by sum(coalesce(a.total_amount_paid,a.value_acquired, 0)) desc limit 20

select b.stock_code, b.short_name, sum(coalesce(a.total_amount_paid,0))::numeric(25,0) as total_amount_paid
from dibots_v2.wvb_dir_dealing a, dibots_v2.exchange_stock_profile b
where a.company_id = b.stock_identifier and b.delisted_date is null and b.eff_end_date is null and exchange = 'BURSA' and
a.company_id = a.dealer_id and a.eff_released_date between '2020-01-01' and '2020-12-31' --and (a.total_treasure_share is not null or a.total_amount_paid is not null) and a.nbr_of_shares_acquired is not null
group by b.stock_code, b.short_name
order by sum(coalesce(a.total_amount_paid, 0)) desc limit 20


select a.wvb_dealing_id, a.company_id, a.company_name, a.dealer_id, a.dealer_name, a.nbr_of_shares_disposed, a.nbr_of_shares_acquired, a.nbr_of_shares_disposed, 
a.price_per_share, a.total_amount_paid, a.total_treasure_share, a.eff_released_date,
value_acquired, value_disposed, net_value, remarks
from dibots_v2.wvb_dir_dealing a, dibots_v2.exchange_stock_profile b
where a.company_id = b.stock_identifier and b.delisted_date is null and b.eff_end_date is null and exchange = 'BURSA' and
a.company_id = a.dealer_id and a.total_treasure_share is not null and a.nbr_of_shares_acquired is not null and a.total_amount_paid is null and a.eff_released_date between '2020-01-01' and '2020-12-31'
order by company_name

select wvb_dealing_id, company_name, dealer_name, eff_released_date, nbr_of_shares, nbr_of_shares_acquired, nbr_of_shares_disposed, price_per_share, total_amount_paid, total_treasure_share, 
value_acquired, value_disposed, net_value, reason_disclosure, remarks
from dibots_v2.wvb_dir_dealing where company_id =dealer_id and eff_released_date >='2020-01-01' and company_nationality ='MYS' and total_treasure_share is null