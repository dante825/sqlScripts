--Sample window function
select f.wvb_hdr_id, f.dbt_entity_id, f.fiscal_period_end_date, now(), 'jeremy' from (
select * from (
select row_number() over (partition by dbt_entity_id, fiscal_period_end_date order by ranking asc), * 
from (select COALESCE((select hierarchy from dibots_v2.ref_report_type_hierarchy b where a.report_type = b.report_type), 999) ranking,* from dibots_v2.data_hdr a
WHERE a.periodicity = 'A' AND extract(year from fiscal_period_end_date) >= 2010 and a.report_type in (select c.report_type from dibots_v2.ref_report_type_hierarchy c where for_analyst=true)) with_ranking
) tmp2 WHERE row_number = 1
)  f left outer join dibots_v2.analyst_hdr_view g on f.dbt_entity_id = g.dbt_entity_id and f.fiscal_period_end_date = g.fiscal_period_end_date
where g.dbt_entity_id is null;

-- windows function to check duplicates
select id, company_id, person_id, role_type, eff_from_date, eff_end_date, deleted from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date, eff_end_date order by id asc) as row_number, *
from dibots_v2.company_person_role ou) tmp

select c.provider_id, concat('unknown@', btrim(split_part(c.email, '@', 2))) as email from (
select row_number() over (partition by b.provider_id order by b.analyst_id asc) as row_number, a.provider_id, b.analyst_id, a.provider_name, b.email
from dibots_v2.ee_providers a left join dibots_v2.ee_analysts b 
on a.provider_id = b.provider_id
where b.email is not null) c
where c.row_number = 1

select row_number() over (partition by company_id, person_id, role_type, eff_from_date, eff_end_date order by id asc) as row_number, *
from dibots_v2.company_person_role ou
where person_id = '504660b7-c2b9-45b0-ab91-50aaa1ef2a80'

--soft delete those row_number != 1
update dibots_v2.company_person_role
set deleted = true
where id in (
select id from (
select row_number() over (partition by company_id, person_id, role_type, eff_from_date order by id desc) as row_number, *
from dibots_v2.company_person_role ou) tmp
where row_number <> 1);

-- SDN BHD in wvb_company_subsidiary that is not in malaysia or brunei
select * from dibots_v2.wvb_company_subsidiary where country_iso_code not in ('MYS', 'BRN') and (subsidiary_long_name like '%SDN BHD' or subsidiary_long_name like '%SDN. BHD.' or subsidiary_long_name like '%SDN.BHD'
or subsidiary_long_name like '%SDNBHD' or subsidiary_long_name like '%SDN BHD %' or subsidiary_long_name like '%SDN. BHD. %')

-- regex replace matching
regexp_replace(lower(company_name), '[^A-Za-z0-9]', '', 'g')

-- regex matching ends with alphabets
select '0198' ~* '.*[A-Z$]'

-- possibly the day watch query
select aa.*,ab.stock_name,ab.opening_price,ac.max_price,ad.min_price, ((ac.max_price/ab.opening_price) -1 ) * 100 as pct_gain_at_max, ((ad.min_price/ab.opening_price) - 1 ) * 100 as pct_loss_at_min  from
(select min(t1.transaction_date) as opening_price_date, t1.stock_code from
(select z.*,y.transaction_date, y.factor, y.opening_price, y.closing_price,y.high_price from
(select a.trading_date, a.stock_code, a.stock_name from
(select * 
from dibots_v2.exchange_foreign_inst_nom_ma
where trading_date > '2021-10-01' and sma_vol5 > sma_vol10 and sma_vol10 > sma_vol20  and sma_buy5 > sma_sell5 and sma_buy10 > sma_sell10 and sma_buy20 > sma_sell20) a
join dibots_v2.demography_period_net_val_view b on a.stock_code = b.stock_code and a.trading_date = b.trading_date and foreign_inst_5 > foreign_inst_10 and foreign_inst_10 > foreign_inst_20 and length(b.stock_code) < 6
order by a.trading_date desc) z
join dibots_v2.exchange_daily_transaction y on z.stock_code = y.stock_code and z.trading_date < y.transaction_date ) t1
group by t1.stock_code) aa
join
(select z.*,y.transaction_date, y.factor, y.opening_price, y.closing_price,y.high_price from
(select a.trading_date, a.stock_code, a.stock_name from
(select * 
from dibots_v2.exchange_foreign_inst_nom_ma
where trading_date > '2021-10-01' and sma_vol5 > sma_vol10 and sma_vol10 > sma_vol20  and sma_buy5 > sma_sell5 and sma_buy10 > sma_sell10 and sma_buy20 > sma_sell20) a
join dibots_v2.demography_period_net_val_view b on a.stock_code = b.stock_code and a.trading_date = b.trading_date and foreign_inst_5 > foreign_inst_10 and foreign_inst_10 > foreign_inst_20 and length(b.stock_code) < 6
order by a.trading_date desc) z
join dibots_v2.exchange_daily_transaction y on z.stock_code = y.stock_code and z.trading_date < y.transaction_date) ab on aa.opening_price_date = ab.transaction_date and aa.stock_code = ab.stock_code
join
(select max(t1.high_price) as max_price, t1.stock_code from
(select z.*,y.transaction_date, y.factor, y.opening_price, y.closing_price,y.high_price from
(select a.trading_date, a.stock_code, a.stock_name from
(select * 
from dibots_v2.exchange_foreign_inst_nom_ma
where trading_date > '2021-10-01' and sma_vol5 > sma_vol10 and sma_vol10 > sma_vol20  and sma_buy5 > sma_sell5 and sma_buy10 > sma_sell10 and sma_buy20 > sma_sell20) a
join dibots_v2.demography_period_net_val_view b on a.stock_code = b.stock_code and a.trading_date = b.trading_date and foreign_inst_5 > foreign_inst_10 and foreign_inst_10 > foreign_inst_20 and length(b.stock_code) < 6
order by a.trading_date desc) z
join dibots_v2.exchange_daily_transaction y on z.stock_code = y.stock_code and z.trading_date < y.transaction_date ) t1
group by t1.stock_code) ac on aa.stock_code = ac.stock_code
join
(select min(t1.low_price) as min_price, t1.stock_code from
(select z.*,y.transaction_date, y.factor, y.opening_price, y.closing_price,y.low_price from
(select a.trading_date, a.stock_code, a.stock_name from
(select * 
from dibots_v2.exchange_foreign_inst_nom_ma
where trading_date > '2021-10-01' and sma_vol5 > sma_vol10 and sma_vol10 > sma_vol20  and sma_buy5 > sma_sell5 and sma_buy10 > sma_sell10 and sma_buy20 > sma_sell20) a
join dibots_v2.demography_period_net_val_view b on a.stock_code = b.stock_code and a.trading_date = b.trading_date and foreign_inst_5 > foreign_inst_10 and foreign_inst_10 > foreign_inst_20 and length(b.stock_code) < 6
order by a.trading_date desc) z
join dibots_v2.exchange_daily_transaction y on z.stock_code = y.stock_code and z.trading_date < y.transaction_date ) t1
group by t1.stock_code) ad on aa.stock_code = ad.stock_code

