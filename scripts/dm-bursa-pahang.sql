--==========================
-- Extraction for Bursa
-- Directors in PLCS who have PAHANG address
--============================================

-- PLCs with Pahang address
select a.stock_code, a.short_name, a.company_name, b.address_type, --b.address_line_1, b.address_line_2, b.address_line_3, b.address_line_4, 
b.postcode, b.city --, b.state, b.state_code, b.country
from dibots_v2.exchange_stock_profile a
join dibots_v2.address_master b on a.stock_identifier = b.dbt_entity_id
where a.eff_end_date is null and a.delisted_date is null and b.eff_end_date is null
and (lower(b.city) like '%kuantan%' or lower(b.city) like '%pahang%' or lower(b.state) like '%pahang%' or lower(b.address_line_3) like '%pahang%' or lower(b.address_line_3) like '%kuantan%'
or lower(b.address_line_4) like '%pahang%' or lower(b.address_line_4) like '%kuantan%')


-- 1. get PLCs with their respective directors
-- 2. get the addresses of the directors
-- 3. get those directors with addresses in pahang

-- only 56 records
select c.*, d.address_type, d.eff_from_date, d.address_line_1, d.address_line_2, d.address_line_3, d.address_line_4, d.postcode, d.city, d.state
from
(select a.stock_code, a.short_name, a.company_name, b.person_id, b.role_type, b.eff_from_date, b.role_desc, b.is_board_member, b.is_officer
from dibots_v2.exchange_stock_profile a
join dibots_v2.company_person_role b on a.stock_identifier = b.company_id 
where a.eff_end_date is null and a.delisted_date is null and b.eff_end_date is null and b.role_type not in ('SEC', 'ASTSEC', 'CONTROL', 'INVREL', 'SHARIA', 'SUSTAIN', 'TREA', 'FO')) c
inner join dibots_v2.address_master d on c.person_id = d.dbt_entity_id
where d.eff_end_date is null
and (lower(d.city) like '%kuantan%' or lower(d.city) like '%pahang%' or lower(d.state) like '%pahang%' or lower(d.address_line_3) like '%pahang%' or lower(d.address_line_3) like '%kuantan%')

-- 1. get PLCs with their respective directors
-- 2. get the directors IC
-- 3. extract state code in IC

select c.*, d.identifier
from (
select a.stock_code, a.short_name, a.company_name, a.stock_identifier, b.person_id, b.role_type, b.eff_from_date, b.role_desc
from dibots_v2.exchange_stock_profile a
join dibots_v2.company_person_role b on a.stock_identifier = b.company_id 
where a.eff_end_date is null and a.delisted_date is null and b.eff_end_date is null and b.role_type not in ('SEC', 'ASTSEC', 'CONTROL', 'INVREL', 'SHARIA', 'SUSTAIN', 'TREA', 'FO')) c
left join dibots_v2.entity_identifier d on c.person_id = d.dbt_entity_id and d.identifier_type = 'MK' and d.eff_end_date is null


create temp table tmp_bursa_dir_plc (
stock_code varchar(10),
stock_name varchar(100),
company_name varchar(255),
company_id uuid,
person_id uuid,
person_name varchar(255),
role_type varchar(100),
role_desc varchar(255),
person_mk varchar(255),
mk_state_code varchar(5),
person_address_city varchar(255)
);

select * from tmp_bursa_dir_plc;

insert into tmp_bursa_dir_plc (stock_code, stock_name, company_name, company_id, person_id, role_type, role_desc, person_mk)
select c.stock_code, c.short_name, c.company_name, c.stock_identifier, c.person_id, c.role_type, c.role_desc, d.identifier
from (
select a.stock_code, a.short_name, a.company_name, a.stock_identifier, b.person_id, b.role_type, b.eff_from_date, b.role_desc
from dibots_v2.exchange_stock_profile a
join dibots_v2.company_person_role b on a.stock_identifier = b.company_id 
where a.eff_end_date is null and a.delisted_date is null and b.eff_end_date is null and b.role_type not in ('SEC', 'ASTSEC', 'CONTROL', 'INVREL', 'SHARIA', 'SUSTAIN', 'TREA', 'FO')) c
left join dibots_v2.entity_identifier d on c.person_id = d.dbt_entity_id and d.identifier_type = 'MK' and d.eff_end_date is null


update tmp_bursa_dir_plc a
set
person_name = b.display_name
from dibots_v2.person_profile b
where a.person_id = b.dbt_entity_id;

update tmp_bursa_dir_plc a
set
person_address_city = b.city
from dibots_v2.address_master b
where a.person_id = b.dbt_entity_id and b.eff_end_date is null and b.deleted = false
and (lower(b.city) like '%kuantan%' or lower(b.city) like '%pahang%' or lower(b.state) like '%pahang%' or lower(b.address_line_3) like '%pahang%' or lower(b.address_line_3) like '%kuantan%');

select * from tmp_bursa_dir_plc a, dibots_v2.address_master b
where a.person_id = b.dbt_entity_id and b.eff_end_date is null and b.deleted = false
and (lower(b.city) like '%kuantan%' or lower(b.city) like '%pahang%' or lower(b.state) like '%pahang%' or lower(b.address_line_3) like '%pahang%' or lower(b.address_line_3) like '%kuantan%')

select * from dibots_v2.address_master where dbt_entity_id = '26e72896-4ed1-4475-a224-fc0091d976b7'

select person_mk, substr(person_mk, 7, 2) from tmp_bursa_dir_plc 

update tmp_bursa_dir_plc
set
mk_state_code = substr(person_mk, 7, 2)

-- has duplicates, for person holding multiple roles in a company
select stock_code, stock_name, company_id, company_name, person_id, person_name, role_type, role_desc, person_mk, mk_state_code, person_address_city
from tmp_bursa_dir_plc where mk_state_code in ('06', '32', '33') or person_address_city is not null
order by stock_code asc

-- less duplicates but a person still could have multiple records because a person can have several directorships from different companies
select stock_code, stock_name, company_name, person_name, max(role_type), max(role_desc), person_mk, mk_state_code, person_address_city
from tmp_bursa_dir_plc where mk_state_code in ('06', '32', '33') or person_address_city is not null
group by stock_code, stock_name, company_name, person_name, person_mk, mk_state_code, person_address_city


-- PLCs subsidiary in Pahang
-- 1. stock_profile + subsidiary + address_master
-- 2. + address_master
-- 3. filter

select c.stock_code, c.short_name as stock_name, c.company_name, c.subsidiary_short_name as subsidiary_name, c.percent_ownership, c.indirect_percent_ownership, c.subsidiary_relationship_type,
d.address_type,  d.address_line_1, d.address_line_2, d.address_line_3, d.address_line_4, d.postcode, d.city, d.state from 
(select a.stock_code, a.short_name, a.company_name, a.stock_identifier, b.subsidiary_id, b.subsidiary_short_name, b.subsidiary_long_name, b.percent_ownership, b.indirect_percent_ownership, b.subsidiary_relationship_type,
b.country_iso_code, b.acquisition_date
from dibots_v2.exchange_stock_profile a 
inner join dibots_v2.wvb_company_subsidiary b on a.stock_identifier = b.company_id
where b.disposal_date is null and a.eff_end_date is null and a.delisted_date is null) c
join dibots_v2.address_master d on c.subsidiary_id = d.dbt_entity_id
where d.eff_end_date is null --and d.address_type = 'CORP'
and (lower(d.city) like '%kuantan%' or lower(d.city) like '%pahang%' or lower(d.state) like '%pahang%' or lower(d.address_line_3) like '%pahang%' or lower(d.address_line_3) like '%kuantan%'
or lower(d.address_line_4) like '%pahang%' or lower(d.address_line_4) like '%kuantan%')
order by c.stock_code asc;

