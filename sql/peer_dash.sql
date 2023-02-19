-- constructing a view of 3 years financial reports of malaysia PLCs

--=========================
-- PLC_3YEARS_FIN_VIEW
--=========================

-- this is getting the financial reports from 3 years ago (2019 to 2022) not getting the latest 3 years reports for each company, that would need window function on the analyst_hdr table

-- drop view dibots_v2.plc_3years_fin_view;
create or replace view dibots_v2.plc_3years_fin_view as
-- getting data from wvb_calc_item_value
SELECT esp.stock_identifier as dbt_entity_id,
	esp.stock_identifier_ex as external_id,
    esp.stock_code,
    esp.company_name,
    hdr.wvb_hdr_id,
    hdr.fiscal_period_end_date,
    date_part('year'::text, hdr.fiscal_period_end_date) AS fiscal_year,
    civ.data_item_id,
        CASE 
        WHEN civ.data_item_id=3000 THEN 'revenue'
        WHEN civ.data_item_id=3037 THEN 'net_profit'
        WHEN civ.data_item_id=3072 THEN 'goodwill_intangible'
        WHEN civ.data_item_id=3077 THEN 'total_asset'
        WHEN civ.data_item_id=4041 THEN 'shareholder_equity'
        WHEN civ.data_item_id=5024 THEN 'roe'
        WHEN civ.data_item_id=5514 THEN 'operating_cash_flow'
        WHEN civ.data_item_id=5523 THEN 'dividend_paid'
    END AS fiscal_item,
    civ.numeric_value
   FROM dibots_v2.exchange_stock_profile esp,
    dibots_v2.analyst_hdr hdr,
    dibots_v2.wvb_calc_item_value civ
  WHERE esp.stock_identifier = hdr.dbt_entity_id AND hdr.wvb_hdr_id = civ.wvb_hdr_id AND (esp.eff_end_date IS NULL OR esp.eff_end_date > hdr.fiscal_period_end_date) 
  AND esp.eff_from_date <= hdr.fiscal_period_end_date AND esp.stock_identifier IS NOT NULL AND (civ.data_item_id = ANY (ARRAY[3037, 3077, 3072, 5514, 5523, 3000, 4041])) 
  AND date_part('year'::text, hdr.fiscal_period_end_date) >= date_part('year'::text, now() - '3 years'::interval year) AND date_part('year'::text, hdr.fiscal_period_end_date) <= date_part('year'::text, now())
UNION
-- getting data from wvb_ratio_item_value
  SELECT esp.stock_identifier as dbt_entity_id,
    esp.stock_identifier_ex as external_id,
    esp.stock_code,
    esp.company_name,
    hdr.wvb_hdr_id,
    hdr.fiscal_period_end_date,
    date_part('year'::text, hdr.fiscal_period_end_date) AS fiscal_year,
    riv.data_item_id,
        CASE 
        WHEN riv.data_item_id=5024 THEN 'roe'
    END AS fiscal_item,
    riv.numeric_value
FROM dibots_v2.exchange_stock_profile esp,
    dibots_v2.analyst_hdr hdr,
    dibots_v2.wvb_ratio_item_value riv
  WHERE esp.stock_identifier = hdr.dbt_entity_id AND hdr.wvb_hdr_id = riv.wvb_hdr_id AND (esp.eff_end_date IS NULL OR esp.eff_end_date > hdr.fiscal_period_end_date) AND esp.eff_from_date <= hdr.fiscal_period_end_date 
  AND esp.stock_identifier IS NOT NULL 
  AND (riv.data_item_id = ANY (ARRAY[5024])) 
  AND date_part('year'::text, hdr.fiscal_period_end_date) >= date_part('year'::text, now() - '3 years'::interval year) AND date_part('year'::text, hdr.fiscal_period_end_date) <= date_part('year'::text, now());

-- use crosstab to pivot the table
-- would have problem if a data item is missing
select * from crosstab('select wvb_hdr_id, data_item_id, numeric_value from dibots_v2.plc_3years_fin_view order by 1, 2') 
as ct (wvb_hdr_id bigint, item_3000 numeric(25,5), item_3037 numeric(25,5), item_3072 numeric(25,5),
item_3077 numeric(25,5), item_4041 numeric(25,5), item_5024 numeric(25,5), item_5514 numeric(25,5), item_5523 numeric(25,5))

--======================
-- PLC_FIN_DATA_VIEW
--=====================

-- pivot the view above, 1 data item 1 column
select wvb_hdr_id, 
max(case when (data_item_id = 3000) then numeric_value else NULL end) as revenue,
max(case when (data_item_id = 3037) then numeric_value else NULL end) as net_profit,
max(case when (data_item_id = 3072) then numeric_value else NULL end) as goodwill_tangible,
max(case when (data_item_id = 3077) then numeric_value else NULL end) as total_asset,
max(case when (data_item_id = 4041) then numeric_value else NULL end) as shareholder_equity,
max(case when (data_item_id = 5024) then numeric_value else NULL end) as roe,
max(case when (data_item_id = 5514) then numeric_value else NULL end) as operating_cash_flow,
max(case when (data_item_id = 5523) then numeric_value else NULL end) as dividend_paid
from dibots_v2.plc_3years_fin_view
group by wvb_hdr_id
order by wvb_hdr_id


REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.plc_fin_data_view;

-- drop materialized view dibots_v2.plc_fin_data_view;
CREATE MATERIALIZED VIEW dibots_v2.plc_fin_data_view as
select b.dbt_entity_id, b.external_id, b.stock_code, a.wvb_hdr_id, b.fiscal_period_end_date, b.fiscal_year, a.revenue, a.net_profit, a.total_asset, a.shareholder_equity, a.roe, a.operating_cash_flow, a.dividend_paid
from (select wvb_hdr_id, 
max(case when (data_item_id = 3000) then numeric_value else NULL end) as revenue,
max(case when (data_item_id = 3037) then numeric_value else NULL end) as net_profit,
max(case when (data_item_id = 3072) then numeric_value else NULL end) as goodwill_tangible,
max(case when (data_item_id = 3077) then numeric_value else NULL end) as total_asset,
max(case when (data_item_id = 4041) then numeric_value else NULL end) as shareholder_equity,
max(case when (data_item_id = 5024) then numeric_value else NULL end) as roe,
max(case when (data_item_id = 5514) then numeric_value else NULL end) as operating_cash_flow,
max(case when (data_item_id = 5523) then numeric_value else NULL end) as dividend_paid
from dibots_v2.plc_3years_fin_view
group by wvb_hdr_id
order by wvb_hdr_id) a,
(select c.dbt_entity_id, c.external_id, c.stock_code, c.wvb_hdr_id, c.fiscal_period_end_date, c.fiscal_year from dibots_v2.plc_3years_fin_view c
group by c.dbt_entity_id, c.external_id, c.stock_code, c.wvb_hdr_id, c.fiscal_period_end_date, c.fiscal_year) b
where a.wvb_hdr_id = b.wvb_hdr_id;

CREATE UNIQUE INDEX plc_fin_data_uniq on dibots_v2.plc_fin_data_view (external_id, wvb_hdr_id);
CREATE INDEX plc_fin_data_stock_idx on dibots_v2.plc_fin_data_view (stock_code);


--======================
-- PLC_FIN_STATS_VIEW
--======================

-- create all the statistic of each financial data field

refresh materialized view concurrently dibots_v2.plc_fin_stats_view;

-- drop materialized view dibots_v2.plc_fin_stats_view;
create materialized view dibots_v2.plc_fin_stats_view as
select a.dbt_entity_id, a.external_id, a.stock_code, 
percentile_disc(0.5) within group (order by a.revenue) as median_revenue, avg(a.revenue) as mean_revenue, stddev_pop(a.revenue) as stddev_revenue,
percentile_disc(0.5) within group (order by a.net_profit) as median_net_profit, avg(a.net_profit) as mean_net_profit, stddev_pop(a.net_profit) as stddev_net_profit,
percentile_disc(0.5) within group (order by a.total_asset) as median_total_asset, avg(a.total_asset) as mean_total_asset, stddev_pop(a.total_asset) as stddev_total_asset,
percentile_disc(0.5) within group (order by a.shareholder_equity) as median_shareholder_equity, avg(a.shareholder_equity) as mean_shareholder_equity, stddev_pop(a.shareholder_equity) as stddev_shareholder_equity,
percentile_disc(0.5) within group (order by a.roe) as median_roe, avg(a.roe) as mean_roe, stddev_pop(a.roe) as stddev_roe,
percentile_disc(0.5) within group (order by a.operating_cash_flow) as median_operating_cash_flow, avg(a.operating_cash_flow) as mean_operating_cash_flow, stddev_pop(a.operating_cash_flow) as stddev_operating_cash_flow,
percentile_disc(0.5) within group (order by a.dividend_paid) as median_dividend_paid, avg(a.dividend_paid) as mean_dividend_paid, stddev_pop(a.dividend_paid) as stddev_dividend_paid
from dibots_v2.plc_fin_data_view a
group by a.dbt_entity_id, a.external_id, a.stock_code;

create unique index plc_fin_stats_uniq on dibots_v2.plc_fin_stats_view (external_id);


--=========================
-- INCREMENTAL UPDATE
--=========================
REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.plc_fin_data_view;
REFRESH MATERIALIZED VIEW CONCURRENTLY dibots_v2.plc_fin_stats_view;




-- VERIFICATION
-- stddev = stddev_samp, divide by n-1
-- stddev_pop, divide by n, this should be the one we use
select * from dibots_v2.plc_fin_stats_view where stock_code = '7153'

select * from dibots_v2.plc_fin_data_view where stock_code = '7153'

select stddev(revenue), stddev_pop(revenue) from dibots_v2.plc_fin_data_view a where stock_code = '7153'

select * from dibots_v2.plc_fin_data_view where stock_code = '7153'

select avg(revenue) from dibots_v2.plc_fin_data_view where stock_code = '7153'

select sqrt(sum(pow(revenue-(4162368.33333),2))/2), sqrt(sum(pow(revenue -(4162368.33333),2))/3) from dibots_v2.plc_fin_data_view a where stock_code = '7153'


