-- CLSA data mining

-- sectors
select sector, sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31' and
sector in ('CONSTRUCTION', 'CONSUMER PRODUCTS & SERVICES', 'ENERGY', 'FINANCIAL SERVICES', 'HEALTH CARE', 'INDUSTRIAL PRODUCTS & SERVICES', 'PLANTATION', 'PROPERTY', 'REAL ESTATE INVESTMENT TRUSTS', 
'TECHNOLOGY', 'TELECOMMUNICATIONS & MEDIA', 'TRANSPORTATION & LOGISTICS', 'UTILITIES')
group by sector
order by sector asc;

-- klci
select sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31'
and klci_flag = true;


-- 1. KLCI component stocks
select stock_code, stock_name, sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31' and klci_flag = true
group by stock_code, stock_name
order by stock_code;

-- 2. gloves stock, top glove 7113, hartalega 5168, kossan 7153, supermax 7106
select stock_code, stock_name, sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31'
and stock_code in ('7113', '5168', '7153', '7106')
group by stock_code, stock_name
order by stock_code;

-- 3 tech index component stock, or focus on inari 0166, globetronics 7022, unisem 5005, malaysia pacific industries 6548, pentamaster 7160, vitrox 0097, mi technovation 5286, greatech 0208
select stock_code, stock_name, sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31'
and stock_code in ('0166', '7022', '5005', '6548', '7160', '0097', '5286', '0208')
group by stock_code, stock_name
order by stock_code


--4 banking stock, Maybank 1155, Public Bank 1295, CIMB 1023, RHB Bank 1066, Hong Leong Bank 5819, AMMB Holdings 1015, Alliance Bank 2488, Affin Bank 5185
select stock_code, stock_name, sum(net_local_retail_val)::numeric(25,0) as net_local_retail, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail, 
sum(net_local_inst_val)::numeric(25,0) as net_local_inst, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst,
sum(net_local_nominees_val)::numeric(25,0) as net_local_nom, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nom,
sum(net_ivt_val)::numeric(25,0) as net_ivt, sum(net_pdt_val)::numeric(25,0) as net_pdt
from dibots_v2.exchange_demography_stock_week
where trading_date between '2021-07-01' and '2021-07-31'
and stock_code in ('1155', '1295', '1023', '1066', '5819', '1015', '2488', '5185')
group by stock_code, stock_name
order by stock_code;


-- 5. top 10 volume and value

-- total_volume
select stock_code, stock_name, sum(total_vol)::numeric(25,0) as total_vol, sum(total_val)::numeric(25,0) as total_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(total_vol) desc
limit 10;

-- local_retail
select stock_code, stock_name, sum(local_retail_vol)::numeric(25,0) as local_retail_vol, sum(local_retail_val)::numeric(25,0) as local_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_retail_vol,0)) desc
limit 10;

-- foreign_retail
select stock_code, stock_name, sum(foreign_retail_vol)::numeric(25,0) as foreign_retail_vol, sum(foreign_retail_val)::numeric(25,0) as foreign_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_retail_vol,0)) desc
limit 10;

-- local_inst
select stock_code, stock_name, sum(local_inst_vol)::numeric(25,0) as local_inst_vol, sum(local_inst_val)::numeric(25,0) as local_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_inst_vol,0)) desc
limit 10;

-- foreign_inst
select stock_code, stock_name, sum(foreign_inst_vol)::numeric(25,0) as foreign_inst_vol, sum(foreign_inst_val)::numeric(25,0) as foreign_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_inst_vol,0)) desc
limit 10;

-- local_nominees
select stock_code, stock_name, sum(local_nominees_vol)::numeric(25,0) as local_nominees_vol, sum(local_nominees_val)::numeric(25,0) as local_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_nominees_vol,0)) desc
limit 10;

-- foreign_nominees
select stock_code, stock_name, sum(foreign_nominees_vol)::numeric(25,0) as foreign_nominees_vol, sum(foreign_nominees_val)::numeric(25,0) as foreign_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_nominees_vol,0)) desc
limit 10;

-- ivt
select stock_code, stock_name, sum(ivt_vol)::numeric(25,0) as ivt_vol, sum(ivt_val)::numeric(25,0) as ivt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(ivt_vol,0)) desc
limit 10;

-- pdt
select stock_code, stock_name, sum(pdt_vol)::numeric(25,0) as pdt_vol, sum(pdt_val)::numeric(25,0) as pdt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(pdt_vol,0)) desc
limit 10;


-- top 10 value

-- total_value
select stock_code, stock_name, sum(total_vol)::numeric(25,0) as total_vol, sum(total_val)::numeric(25,0) as total_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(total_val) desc
limit 10;

-- local_retail
select stock_code, stock_name, sum(local_retail_vol)::numeric(25,0) as local_retail_vol, sum(local_retail_val)::numeric(25,0) as local_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_retail_val,0)) desc
limit 10;

-- foreign_retail
select stock_code, stock_name, sum(foreign_retail_vol)::numeric(25,0) as foreign_retail_vol, sum(foreign_retail_val)::numeric(25,0) as foreign_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_retail_val,0)) desc
limit 10;

-- local_inst
select stock_code, stock_name, sum(local_inst_vol)::numeric(25,0) as local_inst_vol, sum(local_inst_val)::numeric(25,0) as local_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_inst_val,0)) desc
limit 10;

-- foreign_inst
select stock_code, stock_name, sum(foreign_inst_vol)::numeric(25,0) as foreign_inst_vol, sum(foreign_inst_val)::numeric(25,0) as foreign_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_inst_val,0)) desc
limit 10;

-- local_nominees
select stock_code, stock_name, sum(local_nominees_vol)::numeric(25,0) as local_nominees_vol, sum(local_nominees_val)::numeric(25,0) as local_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(local_nominees_val,0)) desc
limit 10;

-- foreign_nominees
select stock_code, stock_name, sum(foreign_nominees_vol)::numeric(25,0) as foreign_nominees_vol, sum(foreign_nominees_val)::numeric(25,0) as foreign_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(foreign_nominees_val,0)) desc
limit 10;

-- ivt
select stock_code, stock_name, sum(ivt_vol)::numeric(25,0) as ivt_vol, sum(ivt_val)::numeric(25,0) as ivt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(ivt_val,0)) desc
limit 10;

-- pdt
select stock_code, stock_name, sum(pdt_vol)::numeric(25,0) as pdt_vol, sum(pdt_val)::numeric(25,0) as pdt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(pdt_val,0)) desc
limit 10;

--=======================
-- TOP NET BUY STOCKS
--=======================

-- local_retail
select stock_code, stock_name, sum(net_local_retail_vol)::numeric(25,0) as net_local_retail_vol, sum(net_local_retail_val)::numeric(25,0) as net_local_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_retail_val,0)) desc
limit 10;

-- foreign_retail
select stock_code, stock_name, sum(net_foreign_retail_vol)::numeric(25,0) as net_foreign_retail_vol, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_retail_val,0)) desc
limit 10;

-- local_inst
select stock_code, stock_name, sum(net_local_inst_vol)::numeric(25,0) as net_local_inst_vol, sum(net_local_inst_val)::numeric(25,0) as net_local_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) desc
limit 10;

-- foreign_inst
select stock_code, stock_name, sum(net_foreign_inst_vol)::numeric(25,0) as net_foreign_inst_vol, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_inst_val,0)) desc
limit 10;

-- local_nominees
select stock_code, stock_name, sum(net_local_nominees_vol)::numeric(25,0) as net_local_nominees_vol, sum(net_local_nominees_val)::numeric(25,0) as net_local_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) desc
limit 10;

-- foreign_nominees
select stock_code, stock_name, sum(net_foreign_nominees_vol)::numeric(25,0) as net_foreign_nominees_vol, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_nominees_val,0)) desc
limit 10;

-- ivt
select stock_code, stock_name, sum(net_ivt_vol)::numeric(25,0) as net_ivt_vol, sum(net_ivt_val)::numeric(25,0) as net_ivt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_ivt_val,0)) desc
limit 10;

-- pdt
select stock_code, stock_name, sum(net_pdt_vol)::numeric(25,0) as net_pdt_vol, sum(net_pdt_val)::numeric(25,0) as net_pdt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_pdt_val,0)) desc
limit 10;

--======================
-- TOP NET SELL STOCKS
--======================

-- local_retail
select stock_code, stock_name, sum(net_local_retail_vol)::numeric(25,0) as net_local_retail_vol, sum(net_local_retail_val)::numeric(25,0) as net_local_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_retail_val,0)) asc
limit 10;

-- foreign_retail
select stock_code, stock_name, sum(net_foreign_retail_vol)::numeric(25,0) as net_foreign_retail_vol, sum(net_foreign_retail_val)::numeric(25,0) as net_foreign_retail_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_retail_val,0)) asc
limit 10;

-- local_inst
select stock_code, stock_name, sum(net_local_inst_vol)::numeric(25,0) as net_local_inst_vol, sum(net_local_inst_val)::numeric(25,0) as net_local_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_inst_val,0)) asc
limit 10;

-- foreign_inst
select stock_code, stock_name, sum(net_foreign_inst_vol)::numeric(25,0) as net_foreign_inst_vol, sum(net_foreign_inst_val)::numeric(25,0) as net_foreign_inst_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_inst_val,0)) asc
limit 10;

-- local_nominees
select stock_code, stock_name, sum(net_local_nominees_vol)::numeric(25,0) as net_local_nominees_vol, sum(net_local_nominees_val)::numeric(25,0) as net_local_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_local_nominees_val,0)) asc
limit 10;

-- foreign_nominees
select stock_code, stock_name, sum(net_foreign_nominees_vol)::numeric(25,0) as net_foreign_nominees_vol, sum(net_foreign_nominees_val)::numeric(25,0) as net_foreign_nominees_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_foreign_nominees_val,0)) asc
limit 10;

-- ivt
select stock_code, stock_name, sum(net_ivt_vol)::numeric(25,0) as net_ivt_vol, sum(net_ivt_val)::numeric(25,0) as net_ivt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_ivt_val,0)) asc
limit 10;

-- pdt
select stock_code, stock_name, sum(net_pdt_vol)::numeric(25,0) as net_pdt_vol, sum(net_pdt_val)::numeric(25,0) as net_pdt_val
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(coalesce(net_pdt_val,0)) asc
limit 10;


-- short selling

select stock_code, stock_name, sum(total_volume), sum(total_value)::numeric(25,0)
from dibots_v2.exchange_short_selling
where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(total_volume) desc limit 10;

select stock_code, stock_name, sum(total_volume), sum(total_value)::numeric(25,0)
from dibots_v2.exchange_short_selling
where trading_date between '2021-07-01' and '2021-07-31'
group by stock_code, stock_name
order by sum(total_value) desc limit 10;

-- top 10 foreign net buy stock demography pct

select stock_code, stock_name, sum(net_foreign_val) as net_foreign, (sum(coalesce(local_inst_val,0))/sum(total_val)*100)::numeric(25,2) as local_inst_pct,
(sum(coalesce(local_retail_val,0))/sum(total_val)*100)::numeric(25,2) as local_retail_pct, (sum(coalesce(local_nominees_val,0))/sum(total_val)*100)::numeric(25,2) as local_nom_pct,
(sum(coalesce(foreign_val,0))/sum(total_val)*100)::numeric(25,2) as foreign_pct, (sum(coalesce(ivt_val,0))/sum(total_val)*100)::numeric(25,2) as ivt_pct, (sum(coalesce(pdt_val,0))/sum(total_val)*100)::numeric(25,2) as pdt_pct
from dibots_v2.exchange_demography_stock_week where trading_date between '2021-07-01' and '2021-11-12' 
group by stock_code, stock_name
order by sum(coalesce(net_foreign_val,0)) desc limit 20