--==============================
-- CGS monthly demography data
--==============================

--===============================
-- SECTOR NET BUY SELL (MONTHLY)
--===============================

------------------------------------
-- YEAR 2021, 2022-08-01 to 2022-08-31
------------------------------------

select sector, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_val)::numeric(25,0) as foreign, sum(net_ivt_val)::numeric(25,0) as ivt, sum(net_pdt_val)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by sector order by sector;

------------------------------------
-- YEAR 2020, 2021-08-01 to 2021-08-31
------------------------------------

select sector, sum(net_local_inst_val)::numeric(25,0) as local_inst, sum(net_local_retail_val)::numeric(25,0) as local_retail, sum(net_local_nominees_val)::numeric(25,0) as local_nominees, 
sum(net_foreign_val)::numeric(25,0) as foreign, sum(net_ivt_val)::numeric(25,0) as ivt, sum(net_pdt_val)::numeric(25,0) as pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-08-01' and '2021-08-31'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by sector order by sector;

--=======================
-- DEMOGRAPHIC AGE_BAND
--=======================

select age_band, sum(total_val)::numeric(25,0)
from dibots_v2.exchange_demography_stock_retail_prof where trading_date between '2022-08-01' and '2022-08-31'
group by age_band order by age_band

--========================
-- DEMOGRAPHY GENDER
--========================

select distinct gender from dibots_v2.exchange_demography where trading_date = '2020-10-23'

select gender, sum(gross_traded_value_buy + gross_traded_value_sell)::numeric(25,0) from dibots_v2.exchange_demography
where trading_date between '2019-01-01' and '2019-12-31'
group by gender order by gender

select gender, sum(gross_traded_value_buy + gross_traded_value_sell)::numeric(25,0) from dibots_v2.exchange_demography
where trading_date between '2021-01-01' and '2021-12-31'
group by gender order by gender

select gender, sum(gross_traded_value_buy + gross_traded_value_sell)::numeric(25,0) from dibots_v2.exchange_demography
where trading_date between '2022-08-01' and '2022-08-31'
group by gender order by gender

--===================================
-- TOP NET BUY AND NET SELL (MONTHLY)
--===================================

-----------------
-- AUGUST 2022
-----------------

-- LOCAL INST TOP NET BUY
select stock_code, stock_name, sum(net_local_inst_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) desc limit 10;

-- LOCAL INST TOP NET SELL
select stock_code, stock_name, sum(net_local_inst_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) asc limit 10;

-- RETAIL TOP NET BUY
select stock_code, stock_name, sum(net_retail_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_retail_val,0)) desc limit 10;

-- RETAIL TOP NET SELL
select stock_code, stock_name, sum(net_retail_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_retail_val,0)) asc limit 10;

-- FOREIGN INST TOP NET BUY
select stock_code, stock_name, sum(net_foreign_inst_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_inst_val,0)) desc limit 10;

-- FOREIGN INST TOP NET SELL
select stock_code, stock_name, sum(net_foreign_inst_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_inst_val,0)) asc limit 10;

--FOREIGN TOP NET BUY
select stock_code, stock_name, sum(net_foreign_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_val,0)) desc limit 10;

-- FOREIGN TOP NET SELL
select stock_code, stock_name, sum(net_foreign_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_val,0)) asc limit 10;

-- RETAIL + NOM TOP NET BUY
select stock_code, stock_name, sum(coalesce(net_retail_val,0) + coalesce(net_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_retail_val,0) + coalesce(net_nominees_val,0)) desc limit 10;

-- RETAIL + NOM TOP NET SELL
select stock_code, stock_name, sum(coalesce(net_retail_val,0) + coalesce(net_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_retail_val,0) + coalesce(net_nominees_val,0)) asc limit 10;

-- INST + NOM TOP NET BUY
select stock_code, stock_name, sum(coalesce(net_inst_val,0) + coalesce(net_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_inst_val,0) + coalesce(net_nominees_val,0)) desc limit 10;

-- INST + NOM TOP NET SELL
select stock_code, stock_name, sum(coalesce(net_inst_val,0) + coalesce(net_nominees_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_inst_val,0) + coalesce(net_nominees_val,0)) asc limit 10;

-- PROP TOP NET BUY
select stock_code, stock_name, sum(coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0)) desc limit 10;

-- PROP TOP NET SELL
select stock_code, stock_name, sum(coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0))::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_ivt_val,0) + coalesce(net_pdt_val,0)) asc limit 10;

-- NOMINEES TOP NET BUY
select stock_code, stock_name, sum(net_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_nominees_val,0)) desc limit 10;

-- NOMINEES TOP NET SELL
select stock_code, stock_name, sum(net_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_nominees_val,0)) asc limit 10;

-- LOCAL NOMINEES TOP NET BUY
select stock_code, stock_name, sum(net_local_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) desc limit 10;

-- LOCAL NOMINEES TOP NET SELL
select stock_code, stock_name, sum(net_local_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) asc limit 10;

-- FOREIGN NOMINEES TOP NET BUY
select stock_code, stock_name, sum(net_foreign_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_nominees_val,0)) desc limit 10;

-- FOREIGN NOMINEES TOP NET SELL
select stock_code, stock_name, sum(net_foreign_nominees_val)::numeric(25,0) from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_nominees_val,0)) asc limit 10;

--==================
-- SHORT SELLING
--==================

-- RSS
select stock_code, stock_name, sum(rss_volume), sum(rss_value)::numeric(25,0) 
from dibots_v2.exchange_short_selling where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(rss_value) desc limit 20;

-- IDSS
select stock_code, stock_name, sum(idss_volume), sum(idss_value)::numeric(25,0) 
from dibots_v2.exchange_short_selling where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(idss_value) desc limit 20;

-- PDT
select stock_code, stock_name, sum(pdt_volume), sum(pdt_value)::numeric(25,0) 
from dibots_v2.exchange_short_selling where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(pdt_value) desc limit 20;

-- PSS
select stock_code, stock_name, sum(pss_volume), sum(pss_value)::numeric(25,0) 
from dibots_v2.exchange_short_selling where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(pss_value) desc limit 20;

-- TOTAL
select stock_code, stock_name, sum(total_volume), sum(total_value)::numeric(25,0) 
from dibots_v2.exchange_short_selling where trading_date between '2022-08-01' and '2022-08-31'
group by stock_code, stock_name
order by sum(total_value) desc limit 20;

--==========================
-- SHORT SELLING BY SECTOR
--==========================

select sector, sum(total_volume) as vol, sum(total_value)::numeric(25,0) as val from dibots_v2.exchange_short_selling
where trading_date between '2022-08-01' and '2022-08-31'
and sector in ('CONSTRUCTION','CONSUMER PRODUCTS & SERVICES','ENERGY','FINANCIAL SERVICES','HEALTH CARE','INDUSTRIAL PRODUCTS & SERVICES','PLANTATION','PROPERTY','REAL ESTATE INVESTMENT TRUSTS',
'TECHNOLOGY','TELECOMMUNICATIONS & MEDIA','TRANSPORTATION & LOGISTICS','UTILITIES')
group by sector
order by sum(total_value) desc limit 20;

-- KLCI 

select stock_code, stock_name, sum(net_local_inst_val)::numeric(25,0), sum(net_local_retail_val)::numeric(25,0), sum(net_local_nominees_val)::numeric(25,0), sum(net_foreign_val)::numeric(25,0), 
sum(net_ivt_val)::numeric(25,0), sum(net_pdt_val)::numeric(25,0)
from dibots_v2.exchange_demography_stock_week
where trading_date between '2022-08-01' and '2022-08-31' and klci_flag = true
group by stock_code, stock_name
order by stock_code;
