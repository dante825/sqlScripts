select '0198' ~* '.*[A-Z$]'

-- stock code from etd 1525
select distinct(stock_code) from dibots_v2.exchange_trade_demography where trading_date = '2020-07-28'

-- 950
select * from dibots_v2.company_stock where operating_mic = 'XKLS'

select external_id, count(*) from dibots_v2.company_stock
where operating_mic = 'XKLS'
group by external_id having count(*) > 1

select * from dibots_v2.company_stock where external_id = '3591'

select * from dibots_v2.company_stock where external_id = 31489

-- stock code in etd that does not ends with alphabet 1111
select * from (
select distinct(stock_code) from dibots_v2.exchange_trade_demography where trading_date = '2020-07-29') tmp
where tmp.stock_code !~* '.*[A-Z$]'


-- stock code in etd but not in company_stock 261
select * from (
select * from (
select distinct(stock_code) from dibots_v2.exchange_trade_demography where trading_date = '2020-07-29') tmp
where tmp.stock_code !~* '.*[A-Z$]') a
left join dibots_v2.company_stock b
on a.stock_code = b.stock_code
where b.stock_code is null


select * from dibots_v2.entity_identifier where identifier = '866432' and identifier_type = 'STOCKEX'

select * from dibots_v2.cross_ref where ticker = '866432'


-- previous method in data-query
SELECT ei.identifier FROM dibots_v2.entity_master em, dibots_v2.entity_identifier ei, dibots_v2.cross_ref cr 
WHERE em.external_id = 6149 AND ei.dbt_entity_id = em.dbt_entity_id AND ei.identifier_type = 'STOCKEX' AND ei.eff_end_date is null AND cr.dbt_entity_id = ei.dbt_entity_id AND
cr.ticker = ei.identifier AND cr.mic = 'XKLS'
ORDER BY ei.eff_from_date DESC
LIMIT 1
