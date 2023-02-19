-- bursa_loan_fin

create table bursa_loan_fin (
id serial primary key,
dbt_entity_id uuid,
external_id int,
wvb_company_id int,
fin_year int,
fiscal_period_end_date date,
months_in_period int,
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
debt_to_capital_at_book numeric(25,3),
minority_interest_in_shareholders_equity numeric(25,3),
total_current_assets numeric(25,3),
total_assets numeric(25,3),
gross_investment numeric(25,3),
total_interest_bearing_debt numeric(25,3)
);

insert into bursa_loan_fin (dbt_entity_id, external_id, wvb_company_id, fin_year)
select dbt_entity_id, external_id, wvb_company_id, fin_year from bursa_loan;

insert into bursa_loan_fin (dbt_entity_id, external_id, wvb_company_id, fin_year)
select dbt_entity_id, external_id, wvb_company_id, fin_year-1 from bursa_loan;

insert into bursa_loan_fin (dbt_entity_id, external_id, wvb_company_id, fin_year)
select dbt_entity_id, external_id, wvb_company_id, fin_year-2 from bursa_loan;

select * from bursa_loan_fin where gross_sales is null

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
-- total_current_assets 3061
-- total_assets 3077
-- gross_investments 5002
-- total_interest_bearing_debt 5012

-- getting gross_sales 3000
update bursa_loan_fin bursa
set
gross_sales = calc.numeric_value,
fiscal_period_end_date = hdr.fiscal_period_end_date,
months_in_period = hdr.months_in_period
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3000 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.gross_sales is null;


-- net turnover 3002
update bursa_loan_fin bursa
set
net_turnover = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3002 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.net_turnover is null;


-- ebitda 3018
update bursa_loan_fin bursa
set
ebitda = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3018 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.ebitda is null;


--ebit 3024
update bursa_loan_fin bursa
set
ebit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3024 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.ebit is null;


-- profit_after_tax 3037
update bursa_loan_fin bursa
set
profit_after_tax = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3037 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.profit_after_tax is null;


-- net_profit 3045
update bursa_loan_fin bursa
set
net_profit = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3045 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.net_profit is null;


-- intangibles 3072
update bursa_loan_fin bursa
set
intangibles = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3072 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.intangibles is null;


-- fixed_assets 3068
update bursa_loan_fin bursa
set
fixed_assets = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3068 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.fixed_assets is null;


-- long_term_investments 3064
update bursa_loan_fin bursa
set
long_term_investments = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3064 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A'  and bursa.long_term_investments is null;


-- stocks_inventories 3053
update bursa_loan_fin bursa
set
stocks_inventories = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3053 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.stocks_inventories is null;

-- cash 3050
update bursa_loan_fin bursa
set
cash = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3050 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.cash is null;


-- current_liabilities 4011
update bursa_loan_fin bursa
set
current_liabilities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4011 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.current_liabilities is null;


-- long_term_debt 4012
update bursa_loan_fin bursa
set
long_term_debt = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4012 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.long_term_debt is null;


-- provisions 4020
update bursa_loan_fin bursa
set
provisions = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4020 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.provisions is null;


-- minorities 4018
update bursa_loan_fin bursa
set
minorities = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4018 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.minorities is null;



-- total_shareholders_equity 4041
update bursa_loan_fin bursa
set
total_shareholders_equity = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4041 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.total_shareholders_equity is null;


-- ordinary_dividend 3046
update bursa_loan_fin bursa
set
ordinary_dividend = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3046 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.ordinary_dividend is null;


-- operating_margin 5026
update bursa_loan_fin bursa
set
operating_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5026 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.operating_margin is null;


-- return_on_equity_capital 5024
update bursa_loan_fin bursa
set
return_on_equity_capital = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5024 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.return_on_equity_capital is null;


-- net_profit_margin 5030
update bursa_loan_fin bursa
set
net_profit_margin = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5030 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.net_profit_margin is null;


-- current_ratio 5052
update bursa_loan_fin bursa
set
current_ratio = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5052 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.current_ratio is null;


-- debt_to_capital_at_book 5041
update bursa_loan_fin bursa
set
debt_to_capital_at_book = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5041 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.debt_to_capital_at_book is null;


-- minority_interest_in_shareholders_equity 4057
update bursa_loan_fin bursa
set
minority_interest_in_shareholders_equity = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 4057 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.minority_interest_in_shareholders_equity is null;

-- total_current_assets 3061
update bursa_loan_fin bursa
set
total_current_assets = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3061 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.total_current_assets is null;

-- total_assets 3077
update bursa_loan_fin bursa
set
total_assets = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3077 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.total_assets is null;

-- gross_investment 5002
update bursa_loan_fin bursa
set
gross_investment = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 5002 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.gross_investment is null;

-- total_interest_bearing_debt 5012
update bursa_loan_fin bursa
set
total_interest_bearing_debt = calc.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_calc_item_value calc
where hdr.dbt_entity_id = bursa.dbt_entity_id and hdr.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 5012 and extract(year from hdr.fiscal_period_end_date) = fin_year and hdr.periodicity = 'A' and bursa.total_interest_bearing_debt is null;


--====================================
-- WVB_CLONE tables
--====================================
-- gross_sales 3000
update bursa_loan_fin bursa
set
gross_sales = calc.numeric_value,
fiscal_period_end_date = hdr.fiscal_period_end_date::date,
months_in_period = hdr.months_in_period
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3000 and bursa.gross_sales is null;

-- net_turnover 3002
update bursa_loan_fin bursa
set
net_turnover = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3002 and bursa.net_turnover is null;

-- ebitda 3018
update bursa_loan_fin bursa
set
ebitda = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3018 and bursa.ebitda is null;

-- ebit 3024
update bursa_loan_fin bursa
set
ebit = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3024 and bursa.ebit is null;

-- profit_after_tax 3037
update bursa_loan_fin bursa
set
profit_after_tax = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3037 and bursa.profit_after_tax is null;


-- net_profit 3045
update bursa_loan_fin bursa
set
net_profit = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3045 and bursa.net_profit is null;

-- intangibles 3072
update bursa_loan_fin bursa
set
intangibles = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3072 and bursa.intangibles is null;


-- fixed_assets 3068
update bursa_loan_fin bursa
set
fixed_assets = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3068 and bursa.fixed_assets is null;


-- long_term_investments 3064
update bursa_loan_fin bursa
set
long_term_investments = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3064 and bursa.long_term_investments is null;

-- stocks_inventories 3053
update bursa_loan_fin bursa
set
stocks_inventories = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3053 and bursa.stocks_inventories is null;


-- cash 3050
update bursa_loan_fin bursa
set
cash = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3050 and bursa.cash is null;


-- current_liabilities 4011
update bursa_loan_fin bursa
set
current_liabilities = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4011 and bursa.current_liabilities is null;

-- long_term_debt 4012
update bursa_loan_fin bursa
set
long_term_debt = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4012 and bursa.long_term_debt is null;

-- provisions 4020
update bursa_loan_fin bursa
set
provisions = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4020 and bursa.provisions is null;

-- minorities 4018
update bursa_loan_fin bursa
set
minorities = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4018 and bursa.minorities is null;

-- total_shareholders_equity 4041
update bursa_loan_fin bursa
set
total_shareholders_equity = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4041 and bursa.total_shareholders_equity is null;

-- ordinary_dividend 3046
update bursa_loan_fin bursa
set
ordinary_dividend = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3046 and bursa.ordinary_dividend is null;

-- operating_margin 5026
update bursa_loan_fin bursa
set
operating_margin = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5026 and bursa.operating_margin is null;

-- return_on_equity_capital 5024
update bursa_loan_fin bursa
set
return_on_equity_capital = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5024 and bursa.return_on_equity_capital is null;

-- net_profit_margin 5030
update bursa_loan_fin bursa
set
net_profit_margin = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5030 and bursa.net_profit_margin is null;


-- current_ratio 5052
update bursa_loan_fin bursa
set
current_ratio = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5052 and bursa.current_ratio is null;

-- debt_to_capital_at_book 5041
update bursa_loan_fin bursa
set
debt_to_capital_at_book = ratio.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_ratio_item_value ratio
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and ratio.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and ratio.data_item_perm_id = 5041 and bursa.debt_to_capital_at_book is null;

-- minority_interest_in_shareholders_equity 4057
update bursa_loan_fin bursa
set
minority_interest_in_shareholders_equity = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 4057 and 
bursa.minority_interest_in_shareholders_equity is null;

-- total_current_assets 3061
update bursa_loan_fin bursa
set
total_current_assets = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3061 and bursa.total_current_assets is null;

-- total_assets 3077
update bursa_loan_fin bursa
set
total_assets = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 3077 and bursa.total_assets is null;

-- gross_investment 5002
update bursa_loan_fin bursa
set
gross_investment = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 5002 and bursa.gross_investment is null;

-- total_interest_bearing_debt 5012
update bursa_loan_fin bursa
set
total_interest_bearing_debt = calc.numeric_value
from wvb_clone.wvb_company_fin_analyst_hdr hdr, wvb_clone.wvb_calc_item_value calc
where hdr.company_perm_id = bursa.wvb_company_id and extract(year from hdr.fiscal_period_end_date) = fin_year and calc.wvb_co_fin_data_hdr_perm_id = hdr.wvb_co_fin_data_hdr_perm_id and calc.data_item_perm_id = 5012 and bursa.total_interest_bearing_debt is null;

-- Exporting the data to csv
select fin.dbt_entity_id, scr.roc, scr.company_name, scr.industry, scr.industry_classification, scr.source, fin.fin_year, fin.fiscal_period_end_date, fin.months_in_period, fin.gross_sales, fin.net_turnover, fin.ebitda, fin.ebit, fin.profit_after_tax, fin.net_profit,
fin.intangibles, fin.fixed_assets, fin.long_term_investments, fin.stocks_inventories, fin.cash, fin.current_liabilities, fin.long_term_debt, fin.provisions, fin.minorities, fin.total_shareholders_equity, fin.ordinary_dividend, 
fin.operating_margin, fin.return_on_equity_capital, fin.net_profit_margin, fin.current_ratio, fin.debt_to_capital_at_book, fin.minority_interest_in_shareholders_equity, fin.total_current_assets, fin.total_assets, fin.gross_investment, fin.total_interest_bearing_debt
from bursa_loan_fin fin, bursa_loan scr
where fin.dbt_entity_id = scr.dbt_entity_id
order by scr.roc, fin.fin_year

select * from bursa_loan_fin where months_in_period <> 12

