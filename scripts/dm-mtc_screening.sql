--drop table tmp_mtc_screening;
create table tmp_mtc_screening (
dbt_entity_id uuid,
external_id int,
roc varchar,
company_name varchar,
industry varchar,
industry_classification varchar,
source varchar,
fiscal_period_end_date_str varchar,
fiscal_period_end_date date,
fin_year int,
gross_sales_str varchar,
gross_sales int,
net_turnover_str varchar,
net_turnover int,
ebitda int,
ebit int,
pat int, 
net_profit int,
intangibles int,
fixed_assets int,
long_term_investments int,
stock_inventories int, 
cash int,
current_liabilities int,
long_term_debt int,
provisions int,
minorities int,
total_shareholders_equity int,
ordinary_dividend int,
operating_margin int,
return_on_equity_capital int,
net_profit_margin int,
current_ratio int,
debt_to_capital_at_book int,
minority_interest_in_shareholders_equity int,
is_listed bool default false
);

select * from tmp_mtc_screening;

update tmp_mtc_screening 
set
fiscal_period_end_date = cast(fiscal_period_end_date_str as date),
gross_sales = cast(regexp_replace(gross_sales_str, ',', '', 'g') as int),
net_turnover = cast(regexp_replace(net_turnover_str, ',', '', 'g') as int)

alter table tmp_mtc_screening drop column fiscal_period_end_date_str, drop column gross_sales_str, drop column net_turnover_str;

-- there is a duplicate on external id
select external_id from tmp_mtc_screening
group by external_id having count(*) > 1

select * from tmp_mtc_screening where external_id = 105517
-- same roc, same external_id, different name and industry

-- add uuid into the table for ease of joining

update tmp_mtc_screening mtc
set
dbt_entity_id = cp.dbt_entity_id
from dibots_v2.company_profile cp
where mtc.external_id = cp.external_id and cp.wvb_entity_type = 'COMP'



-- 1. company listed or previously listed status
select * from dibots_v2.company_profile;

SELECT DISTINCT(comp_status_desc) from dibots_v2.company_profile

select * from tmp_mtc_screening mtc, dibots_v2.company_profile cp
where mtc.external_id = cp.external_id and cp.comp_status_desc = 'PUBLIC'

update tmp_mtc_screening mtc
set
is_listed = true
from dibots_v2.company_profile cp
where mtc.external_id = cp.external_id and cp.comp_status_desc = 'PUBLIC'

update tmp_mtc_screening mtc
set
is_listed = false
from dibots_v2.company_profile cp
where mtc.external_id = cp.external_id and cp.comp_status_desc = 'PRIVATE'

select * from tmp_mtc_screening where is_listed = true

-- 2 identify which of the companies is a subsidiary and which company is its parent
select * from dibots_v2.wvb_company_subsidiary;

select mtc.dbt_entity_id, cp.dbt_entity_id, cp.company_name from tmp_mtc_screening mtc, dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where mtc.dbt_entity_id = subs.subsidiary_id and subs.company_id = cp.dbt_entity_id and cp.comp_status_desc = 'PUBLIC'

alter table tmp_mtc_screening add column is_subsidiary bool default false, add column listed_parent_id uuid, add column listed_parent_name varchar;


update tmp_mtc_screening mtc
set
is_subsidiary = true,
listed_parent_id = subs.company_id,
listed_parent_name = cp.company_name
from dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where mtc.dbt_entity_id = subs.subsidiary_id and subs.company_id = cp.dbt_entity_id and cp.comp_status_desc = 'PUBLIC'

-- 3. do the companies has subsidiary that is listed
select * from tmp_mtc_screening mtc, dibots_v2.wvb_company_subsidiary subs, dibots_v2.company_profile cp
where mtc.dbt_entity_id = subs.company_id and subs.subsidiary_id = cp.dbt_entity_id and cp.comp_status_desc = 'PUBLIC'

select * from tmp_mtc_screening mtc, dibots_v2.wvb_company_subsidiary subs, dibots_v2.equity_security_owner eqo
where mtc.dbt_entity_id = subs.company_id and subs.subsidiary_id = eqo.company_id and eqo.eff_thru_date is null and eqo.is_deleted = false

select * from tmp_mtc_screening mtc, dibots_v2.equity_security_owner eqo
where mtc.dbt_entity_id = eqo.owner_id and eqo.eff_thru_date is null and eqo.is_deleted = false

select * from dibots_v2.equity_security_owner

select * from dibots_v2.wvb_company_subsidiary where company_id = '066116a7-52e0-462a-8323-94912c6092e0'

alter table tmp_mtc_screening add column has_listed_subsidiary bool default false, add column listed subsidiary_name varchar;

update tmp_mtc_screening mtc
set
has_listed_subsidiary = true
from dibots_v2.wvb_company_subsidiary subs, dibots_v2.equity_security_owner eqo
where mtc.dbt_entity_id = subs.company_id and subs.subsidiary_id = eqo.company_id and eqo.eff_thru_date is null and eqo.is_deleted = false

select count(*)  from tmp_mtc_screening where has_listed_subsidiary = true

-- Check if any of the companies is sanctioned
select * from tmp_mtc_screening mtc, dibots_v2.company_profile cp where 
mtc.dbt_entity_id = cp.dbt_entity_id and cp.wvb_entity_type = 'SANC_COMP'

select * from tmp_mtc_screening mtc, dibots_v2.company_profile cp
where regexp_replace(lower(mtc.company_name), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(cp.company_name), '[^A-Za-z0-9]', '', 'g') and cp.wvb_entity_type = 'SANC_COMP';

-- Update the fin data in the screening table
update tmp_mtc_screening mtc
set fin_year = extract(year from mtc.fiscal_period_end_date)

-- getting gross_sales 3000
update tmp_mtc_screening mtc
set
gross_sales = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3000 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

--select count(*) from tmp_mtc_fin where gross_sales is not null and fin_year = 2019

-- net turnover 3002
update tmp_mtc_screening mtc
set
net_turnover = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3002 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- ebitda 3018
update tmp_mtc_screening mtc
set
ebitda = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3018 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

--ebit 3024
update tmp_mtc_screening mtc
set
ebit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3024 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- profit_after_tax 3037
update tmp_mtc_screening mtc
set
pat = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3037 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- net_profit 3045
update tmp_mtc_screening mtc
set
net_profit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3045 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- intangibles 3072
update tmp_mtc_screening mtc
set
intangibles = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3072 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- fixed_assets 3068
update tmp_mtc_screening mtc
set
fixed_assets = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3068 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- long_term_investments 3064
update tmp_mtc_screening mtc
set
long_term_investments = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3064 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- stocks_inventories 3053
update tmp_mtc_screening mtc
set
stock_inventories = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3053 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- cash 3050
update tmp_mtc_screening mtc
set
cash = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3050 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- current_liabilities 4011
update tmp_mtc_screening mtc
set
current_liabilities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4011 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- long_term_debt 4012
update tmp_mtc_screening mtc
set
long_term_debt = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4012 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';


-- provisions 4020
update tmp_mtc_screening mtc
set
provisions = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4020 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- minorities 4018
update tmp_mtc_screening mtc
set
minorities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4018 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- total_shareholders_equity 4041
update tmp_mtc_screening mtc
set
total_shareholders_equity = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4041 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- ordinary_dividend 3046
update tmp_mtc_screening mtc
set
ordinary_dividend = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3046 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';

-- operating_margin 5026
update tmp_mtc_screening mtc
set
operating_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5026 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';


-- return_on_equity_capital 5024
update tmp_mtc_screening mtc
set
return_on_equity_capital = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5024 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';



-- net_profit_margin 5030
update tmp_mtc_screening mtc
set
net_profit_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5030 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';


-- current_ratio 5052
update tmp_mtc_screening mtc
set
current_ratio = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5052 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';



-- debt_to_capital_at_book 5041
update tmp_mtc_screening mtc
set
debt_to_capital_at_book = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5041 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';


-- minority_interest_in_shareholders_equity 4057
update tmp_mtc_screening mtc
set
minority_interest_in_shareholders_equity = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4057 and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and hdr.periodicity = 'A';


