-- tmp_mtc_fundamental_ratio
select * from dibots_v2.wvb_quickview_item_values_view where wvb_hdr_id = 55283426 and data_item_id = 5157

select item_id, model_item_desc from dibots_v2.ref_model_ratio where model_item_desc like '3%'

--drop table tmp_mtc_fundamental_ratio;
create table tmp_mtc_fundamental_ratio (
id serial primary key,
dbt_entity_id uuid,
external_id int,
fin_year int,
y3_avg_after_tax_return_risk numeric(25,2),
y3_avg_total_gross_return_risk numeric(25,2),
y3_cap_avg numeric(25,2),
y3_nopbt_avg numeric(25,2),
y3_nopat_avg numeric(25,2),
y3_copat_avg numeric(25,2),
y3_tgc_avg numeric(25,2),
y3_net_sales_growth_rate numeric(25,2),
y3_sustainable_growth_rate numeric(25,2),
y3_growth_in_net_turnover numeric(25,2),
y3_growth_in_ebitda numeric(25,2),
y3_growth_in_ebit numeric(25,2),
y3_growth_in_net_profit numeric(25,2),
y3_growth_in_noplat numeric(25,2),
y3_growth_in_fixed_assets numeric(25,2),
y3_growth_in_current_assets numeric(25,2),
y3_growth_in_operating_current_assets numeric(25,2),
y3_growth_in_gross_assets numeric(25,2),
y3_growth_in_total_assets numeric(25,2),
y3_growth_in_working_capital numeric(25,2),
y3_growth_in_operating_working_capital numeric(25,2),
y3_growth_in_gross_investment numeric(25,2),
y3_growth_in_total_debt numeric(25,2),
y3_growth_in_cash_flow numeric(25,2),
y3_growth_in_shareholder_equity numeric(25,2)
)


insert into tmp_mtc_fundamental_ratio (dbt_entity_id, external_id, fin_year)
select dbt_entity_id, external_id, fin_year from tmp_mtc_screening;

select * from tmp_mtc_fundamental_ratio;

select ratio.numeric_value from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = '050739a8-cd66-40f5-8cda-7cd4f4916450' and extract(year from hdr.fiscal_period_end_date) = 2018 and hdr.periodicity = 'A'
and hdr.wvb_hdr_id = ratio.wvb_hdr_id and ratio.data_item_id = 5157

--5157	3 Yr Average After-Tax Return Risk (%)
--5158	3 Yr Average Total Gross Return Risk (%)
--5178	3 Yr Cap Average
--5179	3 Yr NOPBT Average
--5180	3 Yr NOPAT Average
--5181	3 Yr COPAT Average
--5182	3 Yr TGC Average
--5159	3 Yr Net Sales Growth Rate (%)
--5177	3 Yr Sustainable Growth Rate (%)
--5168	3 Yr Growth In Net Turnover (%)
--5171	3 Yr Growth In EBITDA (%)
--5172	3 Yr Growth In EBIT (%)
--5173	3 Yr Growth In Net Profit (%)
--5174	3 Yr Growth In NOPLAT (%)
--5164	3 Yr Growth In Fixed Assets (%)
--5161	3 Yr Growth In Current Assets (%)
--5162	3 Yr Growth In Operating Current Assets (%)
--5163	3 Yr Growth In Gross Assets (%)
--5160	3 Yr Growth In Total Assets (%)
--5166	3 Yr Growth In Working Capital (%)
--5176	3 Yr Growth In Operating Working Capital (%)
--5167	3 Yr Growth In Gross Investment (%)
--5165	3 Yr Growth In Total Debt (%)
--5169	3 Yr Growth In Cash Flow (%)
--5175	3 Yr Growth In Shareholder's Equity (%)


--5157	3 Yr Average After-Tax Return Risk (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_avg_after_tax_return_risk = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5157;


--5158	3 Yr Average Total Gross Return Risk (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_avg_total_gross_return_risk = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5158;

--5178	3 Yr Cap Average
update tmp_mtc_fundamental_ratio mtc
set
y3_cap_avg = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5178;

--5179	3 Yr NOPBT Average
update tmp_mtc_fundamental_ratio mtc
set
y3_nopbt_avg = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5179;

--5180	3 Yr NOPAT Average
update tmp_mtc_fundamental_ratio mtc
set
y3_nopat_avg = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5180;

--5181	3 Yr COPAT Average
update tmp_mtc_fundamental_ratio mtc
set
y3_copat_avg = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5181;

--5182	3 Yr TGC Average
update tmp_mtc_fundamental_ratio mtc
set
y3_tgc_avg = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5182;

--5159	3 Yr Net Sales Growth Rate (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_net_sales_growth_rate = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5159;

--5177	3 Yr Sustainable Growth Rate (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_sustainable_growth_rate = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5177;

--5168	3 Yr Growth In Net Turnover (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_net_turnover = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5168;

--5171	3 Yr Growth In EBITDA (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_ebitda = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5171;

--5172	3 Yr Growth In EBIT (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_ebit = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5172;

--5173	3 Yr Growth In Net Profit (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_net_profit = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5173;

--5174	3 Yr Growth In NOPLAT (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_noplat = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5174;

--5164	3 Yr Growth In Fixed Assets (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_fixed_assets = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5164;

--5161	3 Yr Growth In Current Assets (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_current_assets = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5161;

--5162	3 Yr Growth In Operating Current Assets (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_operating_current_assets = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5162;

--5163	3 Yr Growth In Gross Assets (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_gross_assets = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5163;

--5160	3 Yr Growth In Total Assets (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_total_assets = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5160;

--5166	3 Yr Growth In Working Capital (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_working_capital = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5166;

--5176	3 Yr Growth In Operating Working Capital (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_operating_working_capital = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5176;

--5167	3 Yr Growth In Gross Investment (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_gross_investment = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5167;

--5165	3 Yr Growth In Total Debt (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_total_debt = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5165;

--5169	3 Yr Growth In Cash Flow (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_cash_flow = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5169;

--5175	3 Yr Growth In Shareholder's Equity (%)
update tmp_mtc_fundamental_ratio mtc
set
y3_growth_in_shareholder_equity = ratio.numeric_value
from dibots_v2.analyst_hdr_view hdr, dibots_v2.wvb_ratio_item_value ratio
where hdr.dbt_entity_id = mtc.dbt_entity_id and hdr.wvb_hdr_id = ratio.wvb_hdr_id and extract(year from hdr.fiscal_period_end_date) = mtc.fin_year and periodicity = 'A' and ratio.data_item_id = 5175;


-- Output a CSV by merging tmp_mtc_screening and tmp_mtc_fundamental_ratio
select scr.roc, scr.company_name, scr.industry, scr.industry_classification, scr.source, scr.is_listed, scr.is_subsidiary, scr.listed_parent_name, scr.fiscal_period_end_date, scr.gross_sales, scr.net_turnover, scr.ebitda, scr.ebit, scr.pat, 
scr.net_profit, scr.intangibles, scr.fixed_assets, scr.long_term_investments, scr.stock_inventories, scr.cash, scr.current_liabilities, scr.long_term_debt, scr.provisions, scr.minorities, 
scr.total_shareholders_equity, scr.ordinary_dividend, scr.operating_margin, scr.return_on_equity_capital, scr.net_profit_margin, scr.current_ratio, scr.debt_to_capital_at_book, scr.minority_interest_in_shareholders_equity,
fun.y3_avg_after_tax_return_risk, fun.y3_avg_total_gross_return_risk, fun.y3_cap_avg, fun.y3_nopbt_avg, fun.y3_nopat_avg, fun.y3_copat_avg, fun.y3_tgc_avg, fun.y3_net_sales_growth_rate, 
fun.y3_sustainable_growth_rate, fun.y3_growth_in_net_turnover, fun.y3_growth_in_ebitda, fun.y3_growth_in_ebit, fun.y3_growth_in_net_profit, fun.y3_growth_in_noplat, fun.y3_growth_in_fixed_assets, fun.y3_growth_in_current_assets, 
fun.y3_growth_in_operating_current_assets, fun.y3_growth_in_gross_assets, fun.y3_growth_in_total_assets, fun.y3_growth_in_working_capital, fun.y3_growth_in_operating_working_capital, fun.y3_growth_in_gross_investment, 
fun.y3_growth_in_total_debt, fun.y3_growth_in_cash_flow, fun.y3_growth_in_shareholder_equity
from tmp_mtc_screening scr, tmp_mtc_fundamental_ratio fun
where scr.dbt_entity_id = fun.dbt_entity_id

select * from tmp_mtc_screening;