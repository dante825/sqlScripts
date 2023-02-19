select * from tmp_mtc_fin where dbt_entity_id in (select dbt_entity_id from tmp_mtc_fundamental_ratio where y3_avg_after_tax_return_risk is null)
order by external_id, fin_year

select * from tmp_mtc_fundamental_ratio;

select * from tmp_mtc_screening;

-- company that don't have all 3 years report
select company_name from tmp_mtc_screening where dbt_entity_id in (select distinct(dbt_entity_id) from tmp_mtc_fin where gross_sales is null)

-- output those companies that dont have 3 years fin data
select fin.dbt_entity_id, scr.roc, scr.company_name, scr.industry, scr.industry_classification, scr.source, fin.fin_year, fin.fiscal_period_end_date, fin.months_in_period, fin.gross_sales, fin.net_turnover, fin.ebitda, fin.ebit, fin.profit_after_tax, fin.net_profit,
fin.intangibles, fin.fixed_assets, fin.long_term_investments, fin.stocks_inventories, fin.cash, fin.current_liabilities, fin.long_term_debt, fin.provisions, fin.minorities, fin.total_shareholders_equity, fin.ordinary_dividend, 
fin.operating_margin, fin.return_on_equity_capital, fin.net_profit_margin, fin.current_ratio, fin.debt_to_capital_at_book, fin.minority_interest_in_shareholders_equity 
from tmp_mtc_fin fin, tmp_mtc_screening scr
where fin.dbt_entity_id = scr.dbt_entity_id and fin.dbt_entity_id in (select distinct(dbt_entity_id) from tmp_mtc_fin where gross_sales is null)
order by scr.roc, fin.fin_year

select scr.dbt_entity_id, scr.roc, scr.company_name, fin.fin_year, fin.gross_sales, fin.net_turnover, fin.ebitda, fin.ebit, fin.profit_after_tax, fin.net_profit,
fin.intangibles, fin.fixed_assets, fin.long_term_investments, fin.stocks_inventories, fin.cash, fin.current_liabilities, fin.long_term_debt, fin.provisions, fin.minorities, fin.total_shareholders_equity, fin.ordinary_dividend, 
fin.operating_margin, fin.return_on_equity_capital, fin.net_profit_margin, fin.current_ratio, fin.debt_to_capital_at_book, fin.minority_interest_in_shareholders_equity 
from tmp_mtc_fin fin, tmp_mtc_screening scr
where scr.dbt_entity_id = fin.dbt_entity_id and fin.dbt_entity_id = 'caa678dc-0f40-4b0e-bdae-b0a6abf8943c'

-- the ids that 3 yr net sales growth are incorrect
'caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'ENCORAL DIGITAL SOLUTIONS SDN BHD'
'fc904e9e-7f28-4c34-8004-ba8e6a6610f7', 'SRI KERDAU COMMODITIES SDN BHD'
'22c65621-c464-4b12-8639-744ee99d854e', 'KAYEL RUBBER PRODUCTS SDN BHD', 'KAYEL RUBBER INDUSTRIES SDN BHD'
'c417834b-f371-4f64-ab3c-ebe40f4124c1', 
'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'1cbad79e-8066-4c53-9537-15d629f4c99a',


-- A tmp table to store the total
--drop table tmp_total_fin;
create table tmp_total_fin (
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

select * from tmp_mtc_fin;

select * from tmp_mtc_fundamental_ratio

insert into tmp_total_fin
select dbt_entity_id, max(fin_year), sum(gross_sales), sum(net_turnover), sum(ebitda), sum(ebit), sum(net_profit), sum(fixed_assets), sum(total_shareholders_equity), sum(total_current_assets), sum(total_assets),
sum(gross_investment), sum(total_interest_bearing_debt)
from tmp_mtc_fin
group by dbt_entity_id;


select * from tmp_total_fin where dbt_entity_id = '22c65621-c464-4b12-8639-744ee99d854e'

update tmp_total_fin
set
total_gross_sales = total_gross_sales / 2,
total_ebitda = total_ebitda /2,
total_ebit = total_ebit / 2,
total_net_profit = total_net_profit / 2,
total_fixed_assets = total_fixed_assets /2,
total_shareholders_equity = total_shareholders_equity /2,
total_current_assets = total_current_assets / 2,
total_assets = total_assets / 2
where dbt_entity_id = '22c65621-c464-4b12-8639-744ee99d854e'


-- 3 years net sales growth rate
select fin.dbt_entity_id, (fin.gross_sales/((tot.total_gross_sales / 3)) - 1) * 100 as calc_3y_net_sales_growth, fun.y3_net_sales_growth_rate
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id 
and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')

not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')


('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years net turnover growth rate
select fin.dbt_entity_id, (fin.net_turnover/((tot.total_net_turnover / 3)) - 1) * 100 as calc_3y_net_turnover, fun.y3_growth_in_net_turnover
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years ebitda growth rate
select fin.dbt_entity_id, (fin.ebitda/((tot.total_ebitda / 3)) - 1) * 100 as calc_3y_ebitda, fun.y3_growth_in_ebitda
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years ebit growth rate
select fin.dbt_entity_id, (fin.ebit/((tot.total_ebit / 3)) - 1) * 100 as calc_3y_ebit, fun.y3_growth_in_ebit
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years net profit growth rate
select fin.dbt_entity_id, (fin.net_profit/((tot.total_net_profit / 3)) - 1) * 100 as calc_3y_net_profit, fun.y3_growth_in_net_profit
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years growth in fixed assets
select fin.dbt_entity_id, (fin.fixed_assets/((tot.total_fixed_assets / 3)) - 1) * 100 as calc_3y_fixed_assets, fun.y3_growth_in_fixed_assets
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_fixed_assets <> 0
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years total current assets growth rate
select fin.dbt_entity_id, (fin.total_current_assets/((tot.total_current_assets / 3)) - 1) * 100 as calc_3y_total_current_assets, fun.y3_growth_in_current_assets
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_current_assets <> 0
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years total assets growth rate
select fin.dbt_entity_id, (fin.total_assets/(tot.total_assets/3) -1) * 100 as calc_3y_total_assets, fun.y3_growth_in_total_assets
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_assets <> 0
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years gross investment growth rate
select fin.dbt_entity_id, (fin.gross_investment / (tot.total_gross_investment/3) -1) * 100 as calc_3y_gross_investment, fun.y3_growth_in_gross_investment
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')


-- 3 years total debt growth rate
select fin.dbt_entity_id, (fin.total_interest_bearing_debt / (tot.total_interest_bearing_debt/3) - 1) * 100 as calc_3y_total_debt, fun.y3_growth_in_total_debt
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')

-- 3 years growth in shareholders equity
select fin.dbt_entity_id, (fin.total_shareholders_equity/((tot.total_shareholders_equity / 3)) - 1) * 100 as calc_3y_shareholders_equity, fun.y3_growth_in_shareholder_equity
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and tot.total_shareholders_equity <> 0
--and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')
and fin.dbt_entity_id not in
('0b3a19d3-6273-44be-9895-c3d7207e4095',
'66fac2dc-03cb-446b-85f8-4c86f9816f93',
'6e496a99-6d2b-4e64-8285-af68e7067ade',
'a3c58023-df6a-4beb-9de6-eafd58663f1d',
'b67f0e7b-87e1-4a83-a100-4a1efcde756d',
'f32c6dba-ee91-411f-901f-a320d21a7a99')

('6f0f1b64-e248-4dd3-8bbf-6c3a67b4dc1a', 'b67f0e7b-87e1-4a83-a100-4a1efcde756d', '9233fd75-b332-45fc-b341-113e70be6595', 'c417834b-f371-4f64-ab3c-ebe40f4124c1', 'f32c6dba-ee91-411f-901f-a320d21a7a99', '1cbad79e-8066-4c53-9537-15d629f4c99a',
'0b3a19d3-6273-44be-9895-c3d7207e4095', '6e496a99-6d2b-4e64-8285-af68e7067ade', '66fac2dc-03cb-446b-85f8-4c86f9816f93', 'a3c58023-df6a-4beb-9de6-eafd58663f1d', 'e82d9ce6-32f6-4439-85db-7a19de378e45', 'c5d6425b-f7d5-41ab-95a2-0f76a9cb2d1b',
'7dc5d966-4c34-4743-b1ea-a58fec46bc7b', 'c14861b3-420b-48dc-965d-a4a9943ad8c3')


-- an overall
select fin.wvb_company_id, mtc.roc, mtc.company_name, mtc.fiscal_period_end_date, (fin.gross_sales/((tot.total_gross_sales / 3)) - 1) * 100 as calc_3y_net_sales_growth, fun.y3_net_sales_growth_rate,
(fin.net_turnover/((tot.total_net_turnover / 3)) - 1) * 100 as calc_3y_net_turnover, fun.y3_growth_in_net_turnover,
(fin.ebitda/((tot.total_ebitda / 3)) - 1) * 100 as calc_3y_ebitda, fun.y3_growth_in_ebitda,
(fin.ebit/((tot.total_ebit / 3)) - 1) * 100 as calc_3y_ebit, fun.y3_growth_in_ebit,
(fin.net_profit/((tot.total_net_profit / 3)) - 1) * 100 as calc_3y_net_profit, fun.y3_growth_in_net_profit,
(fin.fixed_assets/((tot.total_fixed_assets / 3)) - 1) * 100 as calc_3y_fixed_assets, fun.y3_growth_in_fixed_assets,
(fin.total_current_assets/((tot.total_current_assets / 3)) - 1) * 100 as calc_3y_total_current_assets, fun.y3_growth_in_current_assets,
(fin.total_assets/(tot.total_assets/3) -1) * 100 as calc_3y_total_assets, fun.y3_growth_in_total_assets,
(fin.gross_investment / (tot.total_gross_investment/3) -1) * 100 as calc_3y_gross_investment, fun.y3_growth_in_gross_investment,
(fin.total_interest_bearing_debt / (tot.total_interest_bearing_debt/3) - 1) * 100 as calc_3y_total_debt, fun.y3_growth_in_total_debt,
(fin.total_shareholders_equity/((tot.total_shareholders_equity / 3)) - 1) * 100 as calc_3y_shareholders_equity, fun.y3_growth_in_shareholder_equity
from tmp_mtc_fin fin, tmp_total_fin tot, tmp_mtc_fundamental_ratio fun, tmp_mtc_screening mtc
where fin.dbt_entity_id = tot.dbt_entity_id and fin.fin_year = tot.max_fin_year and fin.dbt_entity_id = fun.dbt_entity_id and fin.dbt_entity_id = mtc.dbt_entity_id
and fin.dbt_entity_id in ('caa678dc-0f40-4b0e-bdae-b0a6abf8943c', 'fc904e9e-7f28-4c34-8004-ba8e6a6610f7')

select * from tmp_mtc_fin where dbt_entity_id = '22c65621-c464-4b12-8639-744ee99d854e'