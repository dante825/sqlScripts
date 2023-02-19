-- manual calc 3 years ratios

-- A tmp table to store the total
create table tmp_bursa_total_fin (
dbt_entity_id uuid,
max_fin_year int,
total_gross_sales numeric(26,6),
total_net_turnover numeric(26,6),
total_ebitda numeric(26,6),
total_ebit numeric(26,6),
total_net_profit numeric(26,6),
total_fixed_assets numeric(26,6),
total_shareholders_equity numeric(26,6),
total_current_assets numeric(26,6),
total_assets numeric(26,6),
total_gross_investment numeric(26,6),
total_interest_bearing_debt numeric(26,6)
);

insert into tmp_bursa_total_fin
select dbt_entity_id, max(fin_year), sum(gross_sales), sum(net_turnover), sum(ebitda), sum(ebit), sum(net_profit), sum(fixed_assets), sum(total_shareholders_equity), sum(total_current_assets), sum(total_assets),
sum(gross_investment), sum(total_interest_bearing_debt)
from bursa_loan_fin
group by dbt_entity_id;

select * from tmp_bursa_total_fin;

--93388107-302e-4029-96a6-91b1ba40b39f
a78e7916-436a-4c65-8a99-ce44973a6237
5e9799f9-0882-4235-be5d-44a0e3eb9958
1e7b2bf3-8d92-4572-8e47-e158bbc5052b
db250371-47d4-433b-9fdc-f2d097184b00
234f9d52-ba64-444d-8d3f-33f7daff8fc6
b0e7a92d-6248-4c12-bc07-df7ef8211775
c0cbffd4-f60c-48fe-8d80-505099d90cba
75ed9cd3-d4f4-4933-8db2-54a4288411d2
a128358d-9352-408c-87c5-06e9f86012d5
c767efbf-b782-48d8-8b03-1f46487d6382
3a907172-5bdc-4970-b370-129a9f362928
8541eb53-8fb6-4b81-bf3b-ffc32fdcbf51
15ad64cf-f3aa-439b-b725-e916ab706f3a
a9188a26-8cc7-4aa5-91d2-9cf7020d0d3e
b23209ad-153b-4b77-b875-bd96e0ee077c
19918bc4-afc7-4c08-9797-0d6a45ab213f
5426d7e1-426b-43e7-8f62-1e04b5994ff5
d61fc882-e778-4de9-a06e-ddadc6cec4e4

-- 3 years net sales growth rate
select fin.dbt_entity_id, (fin.gross_sales/((tot.total_gross_sales / 3)) - 1) * 100 as calc_3y_net_sales_growth, fun.y3_net_sales_growth_rate
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id 

-- 3 years net turnover growth rate
select fin.dbt_entity_id, (fin.net_turnover/((tot.total_net_turnover / 3)) - 1) * 100 as calc_3y_net_turnover, fun.y3_growth_in_net_turnover
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id

-- 3 years ebitda growth rate
select fin.dbt_entity_id, (fin.ebitda/((tot.total_ebitda / 3)) - 1) * 100 as calc_3y_ebitda, fun.y3_growth_in_ebitda
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id

-- 3 years ebit growth rate
select fin.dbt_entity_id, (fin.ebit/((tot.total_ebit / 3)) - 1) * 100 as calc_3y_ebit, fun.y3_growth_in_ebit
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id

-- 3 years net profit growth rate
select fin.dbt_entity_id, (fin.net_profit/((tot.total_net_profit / 3)) - 1) * 100 as calc_3y_net_profit, fun.y3_growth_in_net_profit
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id

-- 3 years growth in fixed assets
select fin.dbt_entity_id, (fin.fixed_assets/((tot.total_fixed_assets / 3)) - 1) * 100 as calc_3y_fixed_assets, fun.y3_growth_in_fixed_assets
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_fixed_assets <> 0

-- 3 years total current assets growth rate
select fin.dbt_entity_id, (fin.total_current_assets/((tot.total_current_assets / 3)) - 1) * 100 as calc_3y_total_current_assets, fun.y3_growth_in_current_assets
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_current_assets <> 0

-- 3 years total assets growth rate
select fin.dbt_entity_id, (fin.total_assets/(tot.total_assets/3) -1) * 100 as calc_3y_total_assets, fun.y3_growth_in_total_assets
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_assets <> 0

-- 3 years gross investment growth rate
select fin.dbt_entity_id, (fin.gross_investment / (tot.total_gross_investment/3) -1) * 100 as calc_3y_gross_investment, fun.y3_growth_in_gross_investment
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id


-- 3 years total debt growth rate
select fin.dbt_entity_id, (fin.total_interest_bearing_debt / (tot.total_interest_bearing_debt/3) - 1) * 100 as calc_3y_total_debt, fun.y3_growth_in_total_debt
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id

-- 3 years growth in shareholders equity
select fin.dbt_entity_id, (fin.total_shareholders_equity/((tot.total_shareholders_equity / 3)) - 1) * 100 as calc_3y_shareholders_equity, fun.y3_growth_in_shareholder_equity
from bursa_loan_fin fin, tmp_bursa_total_fin tot, bursa_loan_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_shareholders_equity <> 0
