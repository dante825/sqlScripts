-- adding a column has_dealer_profile to the table

update dibots_v2.wvb_dir_dealing
set
has_dealer_profile = true,
modified_by = 'kangwei',
modified_dtime = now()
where dealer_type in ('CMPY', 'PERSON') and dealer_id is not null;

select count(*) from dibots_v2.wvb_dir_dealing where has_dealer_profile = true

select * from dibots_v2.wvb_dir_dealing where dealer_type in ('CMPY', 'PERSON') and dealer_id is not null and has_dealer_profile is false

-- inst has some problem

select * from dibots_v2.wvb_dir_dealing a
left join dibots_v2.institution_profile b
on a.dealer_id = b.dbt_entity_id
where a.dealer_type = 'INST' and b.dbt_entity_id is null and a.wvb_dealer_id is not null

update dibots_v2.wvb_dir_dealing a
set
dealer_id = b.dbt_entity_id,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.institution_profile b
where a.dealer_type = 'INST' and a.wvb_dealer_id  is not null and a.wvb_dealer_id = b.wvb_institution_id

-- Updating the inst has_dealer_profile field

select * from dibots_v2.wvb_dir_dealing a, dibots_v2.company_profile b
where a.dealer_id = b.dbt_entity_id and a.dealer_type = 'INST' and b.wvb_entity_type = 'COMP' and a.dealer_id is not null

select * from dibots_v2.company_profile where dbt_entity_id = 'c7eeed3d-d195-4eb7-9f09-cbab98988fd3'

select * from dibots_v2.institution_profile where dbt_entity_id = 'c7eeed3d-d195-4eb7-9f09-cbab98988fd3'

update dibots_v2.wvb_dir_dealing a
set
has_dealer_profile = true,
modified_by = 'kangwei',
modified_dtime = now()
from dibots_v2.company_profile b
where a.dealer_id = b.dbt_entity_id and a.dealer_type = 'INST' and b.wvb_entity_type = 'COMP' and a.dealer_id is not null;

-- calculate the net value based on vwap of the day
select a.wvb_dealing_id, a.company_id, b.stock_identifier, b.stock_code, b.company_name, a.net_shares, a.eff_released_date, c.transaction_date, c.vwap, a.amt_paid_value_acq, coalesce(a.net_shares,0) * coalesce(c.vwap) as net_value  
from dibots_v2.wvb_dir_dealing a 
left join dibots_v2.exchange_stock_profile b on a.company_id = b.stock_identifier and b.eff_end_date is null and b.delisted_date is null
left join dibots_v2.exchange_daily_transaction c on  a.eff_released_date = c.transaction_date and b.stock_code = c.stock_code
where a.company_nationality = 'MYS' and a.comp_status_desc = 'PUBLIC' and a.sec_classif_code = 'ORD' and a.price_per_share is null and a.net_shares <> 0 and a.net_value <> coalesce(a.net_shares,0) * coalesce(c.vwap);

update dibots_v2.wvb_dir_dealing deal
set
net_value = res.net_value,
amt_paid_value_acq = coalesce(nullif(res.amt_paid_value_acq, 0), res.net_value),
modified_dtime = now(),
modified_by = 'pentaho_calc'
from 
(select a.wvb_dealing_id, a.company_id, b.stock_identifier, b.stock_code, b.company_name, a.net_shares, a.eff_released_date, c.transaction_date, c.vwap, a.amt_paid_value_acq, coalesce(a.net_shares,0) * coalesce(c.vwap) as net_value  
from dibots_v2.wvb_dir_dealing a 
left join dibots_v2.exchange_stock_profile b on a.company_id = b.stock_identifier and b.eff_end_date is null and b.delisted_date is null
left join dibots_v2.exchange_daily_transaction c on  a.eff_released_date = c.transaction_date and b.stock_code = c.stock_code
where a.company_nationality = 'MYS' and a.comp_status_desc = 'PUBLIC' and a.sec_classif_code = 'ORD' and a.price_per_share is null and a.net_shares <> 0 and a.net_value <> coalesce(a.net_shares,0) * coalesce(c.vwap)) res
where deal.wvb_dealing_id = res.wvb_dealing_id;