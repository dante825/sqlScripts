-- task 4: getting all the financial information for the sc companies
--drop table if exists tmp_sc_fin;
create table tmp_sc_fin (
id serial primary key,
dbt_entity_id uuid,
external_id integer,
company_name varchar,
credit_data_year integer,
iso_currency_code varchar,
st_rating varchar,
fin_data_year integer,
gross_sales numeric(25,3),
net_turnover numeric(25,3),
ebitda numeric(25,3),
ebit numeric(25,3),
profit_after_tax numeric(25,3),
net_profit numeric(25,3),
intangibles numeric(25,3),
fixed_assets numeric(25,3),
long_term_investments numeric(25,3),
stocks_inventories numeric(25,3),
cash numeric(25,3),
current_liabilities numeric(25,3),
long_term_debt numeric(25,3),
provisions numeric(25,3),
minorities numeric(25,3),
total_shareholders_equity numeric(25,3),
ordinary_dividend numeric(25,3),
operating_margin numeric(25,3),
return_on_equity_capital numeric(25,3),
net_profit_margin numeric(25,3),
current_ratio numeric(25,3),
debt_to_capital_at_book numeric(25,3)
);

-- insert the company ids and names into tmp_sc_fin
insert into tmp_sc_fin (dbt_entity_id, external_id, company_name)
select dbt_entity_id, external_id, company from tmp_sc_list;

--Update the IDs of the table from tmp_sc_list
select count(*) from tmp_sc_fin where dbt_entity_id is null

select * from tmp_sc_fin scfin, tmp_sc_list sc
where scfin.company_name = sc.company and scfin.dbt_entity_id is null;

update tmp_sc_fin scfin
set
dbt_entity_id = sc.dbt_entity_id,
external_id = sc.external_id,
wvb_company_id = sc.wvb_company_id
from tmp_sc_list sc
where scfin.company_name = sc.company --and scfin.dbt_entity_id is null;


select count(*) from tmp_sc_fin where gross_sales is null; --125


-- getting the credit_risk_ratings
update tmp_sc_fin sc
set 
credit_data_year = cre.data_year,
iso_currency_code = cre.iso_currency_code,
st_rating = cre.st_rating
from dibots_v2.wvb_credit_risk_rating cre
where sc.dbt_entity_id = cre.dbt_entity_id and cre.data_year = 2018 --and sc.st_rating is null

select count(*) from tmp_sc_fin where st_rating is not null and credit_data_year = 2018

select count(*) from tmp_sc_fin sc, dibots_v2.wvb_credit_risk_rating cre where sc.dbt_entity_id = cre.dbt_entity_id and cre.data_year = 2019;

select * from tmp_sc_fin where iso_currency_code is null;

select * from dibots_v2.wvb_credit_risk_rating where dbt_entity_id = '3e38999c-8a67-43d5-8b93-8cad8fde8e60';

-- details in FIN_DATA_FORMAT_MODEL_ITEM table, search with data_item_perm_id and fmt_model_perm_id
-- quickview data item_id
-- gross_sales 3000
-- net_turnover 3002
-- ebitda 3018
-- ebit 3024
-- profit_after_tax 3037
-- net_profit 3045
-- intangibles 3072
-- fixed_assets 3068
-- long_term_investments 3064
-- stocks_inventories 3053
-- cash 3050
-- current_liabilities 4011
-- long_term_debt 4012
-- provisions 4020
-- minorities 4018
-- total_shareholders_equity 4041
-- ordinary_dividend 3046
-- operating_margin 5026
-- return_on_equity_capital 5024
-- net_profit_margin 5030
-- current_ratio 5052
-- debt_to_capital_at_book 5041
-- minority_interest_in_shareholders_equity 4057

-- getting gross_sales 3000
select * from dibots_v2.analyst_hdr_view hdr, tmp_sc_list sc, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from fiscal_period_end_date) = 2018 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3000
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3000;

select * from tmp_sc_fin sc, wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where sc.wvb_company_id = hdr.company_perm_id and extract(year from hdr.fiscal_period_end_date) = 2018 and hdr.wvb_co_fin_data_hdr_perm_id = calc.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3000;

update tmp_sc_fin sc
set
fin_data_year = extract(year from hdr.fiscal_period_end_date),
gross_sales = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2018 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3000
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3000 and sc.gross_sales is null

select count(*) from tmp_sc_fin where gross_sales is not null;

update tmp_sc_fin sc
set gross_sales = null,
fin_data_year = null,
fiscal_period_end_date = null;

update tmp_sc_fin sc
set
fin_data_year = extract(year from hdr.fiscal_period_end_date),
fiscal_period_end_date = hdr.fiscal_period_end_date,
gross_sales = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3000 and sc.gross_sales is null;

-- net turnover 3002
update tmp_sc_fin sc
set
net_turnover = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3002
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3002 and sc.net_turnover is null

select count(*) from tmp_sc_fin where net_turnover is not null;

update tmp_sc_fin sc
set net_turnover = null;

update tmp_sc_fin sc
set
net_turnover = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3002 and net_turnover is null;

-- ebitda 3018
update tmp_sc_fin sc
set
ebitda = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3018
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3018 and sc.ebitda is null

select count(*) from tmp_sc_fin where ebitda is not null;

update tmp_sc_fin sc
set ebitda = null;

update tmp_sc_fin sc
set
ebitda = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3018 and sc.ebitda is null;

--ebit 3024
update tmp_sc_fin sc
set
ebit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3024
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3024 and sc.ebit is null;

select count(*) from tmp_sc_fin where ebit is not null;

update tmp_sc_fin
set ebit = null;

update tmp_sc_fin sc
set
ebit = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3024 and sc.ebit is null;

-- profit_after_tax 3037
update tmp_sc_fin sc
set
profit_after_tax = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3037
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3037 and sc.profit_after_tax is null;

select count(*) from tmp_sc_fin where profit_after_tax is not null;

update tmp_sc_fin
set profit_after_tax = null;

update tmp_sc_fin sc
set
profit_after_tax = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3037 and sc.profit_after_tax is null;

-- net_profit 3045
update tmp_sc_fin sc
set
net_profit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3045
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3045 and sc.net_profit is null;

select count(*) from tmp_sc_fin where net_profit is not null;

update tmp_sc_fin
set net_profit = null;

update tmp_sc_fin sc
set
net_profit = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3045 and sc.net_profit is null

-- intangibles 3072
update tmp_sc_fin sc
set
intangibles = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3072
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3072 and sc.intangibles is null;

select count(*) from tmp_sc_fin where intangibles is not null;

update tmp_sc_fin
set intangibles = null;

update tmp_sc_fin sc
set
intangibles = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3072 and sc.intangibles is null;


-- fixed_assets 3068
update tmp_sc_fin sc
set
fixed_assets = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3068
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3068 and sc.fixed_assets is null

select count(*) from tmp_sc_fin where fixed_assets is not null;

update tmp_sc_fin
set fixed_assets = null;

update tmp_sc_fin sc
set
fixed_assets = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3068 and sc.fixed_assets is null;

-- long_term_investments 3064
update tmp_sc_fin sc
set
long_term_investments = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3064
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3064 and sc.long_term_investments is null;

select count(*) from tmp_sc_fin where long_term_investments is not null;

update tmp_sc_fin
set long_term_investments = null;

update tmp_sc_fin sc
set
long_term_investments = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3064 and sc.long_term_investments is null;

-- stocks_inventories 3053
update tmp_sc_fin sc
set
stocks_inventories = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3053
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3053 and stocks_inventories is null;

select count(*) from tmp_sc_fin where stocks_inventories is not null;

update tmp_sc_fin
set stocks_inventories = null;

update tmp_sc_fin sc
set
stocks_inventories = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3053 and sc.stocks_inventories is null;

-- cash 3050
update tmp_sc_fin sc
set
cash = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3050
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3050 and cash is null;

select count(*) from tmp_sc_fin where cash is not null;

update tmp_sc_fin
set cash = null;

update tmp_sc_fin sc
set
cash = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3050 and sc.cash is null;

-- current_liabilities 4011
update tmp_sc_fin sc
set
current_liabilities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 4011
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 4011 and sc.current_liabilities is null;

select count(*) from tmp_sc_fin where current_liabilities is not null;

update tmp_sc_fin
set current_liabilities = null;

update tmp_sc_fin sc
set
current_liabilities = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4011 and sc.current_liabilities is null;


-- long_term_debt 4012
update tmp_sc_fin sc
set
long_term_debt = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 4012
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 4012 and sc.long_term_debt is null;

select count(*) from tmp_sc_fin where long_term_debt is not null;

update tmp_sc_fin
set long_term_debt = null;

update tmp_sc_fin sc
set
long_term_debt = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4012 and sc.long_term_debt is null;


-- provisions 4020
update tmp_sc_fin sc
set
provisions = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 4020
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 4020 and provisions is null;

select count(*) from tmp_sc_fin where provisions is not null;

update tmp_sc_fin
set provisions = null;

update tmp_sc_fin sc
set
provisions = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4020 and sc.provisions is null;


-- minorities 4018
update tmp_sc_fin sc
set
minorities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 4018
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 4018 and minorities is null;

select count(*) from tmp_sc_fin where minorities is not null;

update tmp_sc_fin
set minorities = null;

update tmp_sc_fin sc
set
minorities = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4018 and sc.minorities is null;


-- total_shareholders_equity 4041
update tmp_sc_fin sc
set
total_shareholders_equity = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 4041
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 4041 and total_shareholders_equity is null;

select count(*) from tmp_sc_fin where total_shareholders_equity is not null;

update tmp_sc_fin
set total_shareholders_equity = null;

update tmp_sc_fin sc
set
total_shareholders_equity = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4041 and sc.total_shareholders_equity is null;

-- ordinary_dividend 3046
update tmp_sc_fin sc
set
ordinary_dividend = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 3046
and calc.wvb_hdr_id = quick.wvb_hdr_id and calc.data_item_id = 3046 and ordinary_dividend is null;

select count(*) from tmp_sc_fin where ordinary_dividend is not null;

update tmp_sc_fin
set ordinary_dividend = null;

update tmp_sc_fin sc
set
ordinary_dividend = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3046 and sc.ordinary_dividend is null;


-- operating_margin 5026
update tmp_sc_fin sc
set
operating_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 5026
and ratio.wvb_hdr_id = quick.wvb_hdr_id and ratio.data_item_id = 5026 and operating_margin is null;

select count(*) from tmp_sc_fin where operating_margin is not null;

update tmp_sc_fin
set operating_margin = null;

update tmp_sc_fin sc
set
fin_data_year = extract(year from hdr.fiscal_period_end_date),
fiscal_period_end_date = hdr.fiscal_period_end_date,
operating_margin = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5026 and sc.operating_margin is null;


-- return_on_equity_capital 5024
update tmp_sc_fin sc
set
return_on_equity_capital = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 5024
and ratio.wvb_hdr_id = quick.wvb_hdr_id and ratio.data_item_id = 5024 and return_on_equity_capital is null;

select count(*) from tmp_sc_fin where return_on_equity_capital is not null;

update tmp_sc_fin
set return_on_equity_capital = null;

update tmp_sc_fin sc
set
return_on_equity_capital = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5024 and sc.return_on_equity_capital is null;


-- net_profit_margin 5030
update tmp_sc_fin sc
set
net_profit_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 5030
and ratio.wvb_hdr_id = quick.wvb_hdr_id and ratio.data_item_id = 5030 and net_profit_margin is null;

select count(*) from tmp_sc_fin where net_profit_margin is not null;

update tmp_sc_fin
set net_profit_margin = null;

update tmp_sc_fin sc
set
net_profit_margin = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5030 and sc.net_profit_margin is null;


-- current_ratio 5052
update tmp_sc_fin sc
set
current_ratio = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 5052
and ratio.wvb_hdr_id = quick.wvb_hdr_id and ratio.data_item_id = 5052 and current_ratio is null;

select count(*) from tmp_sc_fin where current_ratio is not null;

update tmp_sc_fin
set current_ratio = null;

update tmp_sc_fin sc
set
current_ratio = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5052 and sc.current_ratio is null;


-- debt_to_capital_at_book 5041
update tmp_sc_fin sc
set
debt_to_capital_at_book = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.analyst_hdr_quickview_view quick, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = sc.dbt_entity_id and extract(year from hdr.fiscal_period_end_date) = 2017 and periodicity = 'A' and hdr.quickview_model = quick.model_id and hdr.wvb_hdr_id = quick.wvb_hdr_id and quick.item_id = 5041
and ratio.wvb_hdr_id = quick.wvb_hdr_id and ratio.data_item_id = 5041 and debt_to_capital_at_book is null;

select count(*) from tmp_sc_fin where debt_to_capital_at_book is not null;

update tmp_sc_fin
set debt_to_capital_at_book = null;

update tmp_sc_fin sc
set
debt_to_capital_at_book = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5041 and sc.debt_to_capital_at_book is null;

-- minority_interest_in_shareholders_equity 4057
select count(*) from tmp_sc_fin where minority_interest_in_shareholders_equity is null;

update tmp_sc_fin sc
set
minority_interest_in_shareholders_equity = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = sc.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = 2019 and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4057 and sc.minority_interest_in_shareholders_equity is null;








select * from tmp_sc_fin where net_profit is not null;

select * from dibots_v2.analyst_hdr_view where dbt_entity_id = 'f5aff9e0-f74f-4494-86df-c03914edb738';

select * from dibots_v2.analyst_hdr_quickview_view where model_id = 83 and wvb_hdr_id = 22282978;

select * from dibots_v2.analyst_hdr_quickview_view;

select * from dibots_v2.wvb_calc_item_value where wvb_hdr_id = 22282978 and data_item_id = 3000;
