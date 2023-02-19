-- create an institution profile table in dibots_ext schema

--drop table dibots_ext.institution_ext;
CREATE TABLE dibots_ext.institution_ext (
	dbt_entity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	external_id int8 NOT NULL,
	institution_type text NOT NULL,
	institution_name text NOT NULL,
	reported_institution_name text NOT NULL,
	country_of_source text NULL,
	country_of_incorporation text NULL,
	"language" text NULL,
	is_listed bool NULL,
	active bool NULL,
	comp_status text NULL,
	comp_status_desc text NULL,
	is_sanctioned bool NULL,
	remarks text NULL,
	wvb_handling_code int4 NULL,
	wvb_last_update_dtime timestamptz NULL,
	created_dtime timestamptz NOT NULL,
	created_by varchar(100) NOT NULL,
	modified_dtime timestamptz NULL,
	modified_by varchar(100) NULL,
	previous_dbt_entity_id uuid NULL,
	previous_external_id int8 NULL,
	propagated bool NOT NULL DEFAULT false,
	data_source_id text NULL,
	previous_institution_type text NULL,
	source_dbt_entity_id uuid NULL,
	source_external_id int8 NULL,
	native_name text NULL,
	has_insti_name bool NULL,
	glic_flag bool NULL DEFAULT false,	
	CONSTRAINT comp_status_desc_length CHECK ((length(comp_status_desc) <= 100)),
	CONSTRAINT comp_status_length CHECK ((length(comp_status) <= 10)),
	CONSTRAINT company_name_length CHECK ((length(institution_name) <= 4000)),
	CONSTRAINT country_of_incorporation_length CHECK ((length(country_of_incorporation) <= 3)),
	CONSTRAINT country_of_source_length CHECK ((length(country_of_source) <= 3)),
	CONSTRAINT institution_ext_pkey PRIMARY KEY (dbt_entity_id),
	CONSTRAINT institution_type_length CHECK ((length(institution_type) <= 10)),
	CONSTRAINT language_length CHECK ((length(language) <= 8)),
	CONSTRAINT reported_institution_name_length CHECK ((length(reported_institution_name) <= 4000))
)
WITH (
	fillfactor=50
);
CREATE INDEX institution_ext_country_of_incorporation ON dibots_ext.institution_ext USING btree (country_of_incorporation);
CREATE INDEX institution_ext_country_of_source ON dibots_ext.institution_ext USING btree (country_of_source);
CREATE INDEX institution_ext_dbt_entity_id ON dibots_ext.institution_ext USING btree (dbt_entity_id);
CREATE INDEX institution_ext_external_id ON dibots_ext.institution_ext USING btree (external_id);
CREATE INDEX institution_ext_institution_type ON dibots_ext.institution_ext USING btree (institution_type);
CREATE INDEX institution_ext_language ON dibots_ext.institution_ext USING btree (language);
CREATE INDEX institution_ext_old_dbt_entity_id ON dibots_ext.institution_ext USING btree (previous_dbt_entity_id) WHERE (previous_dbt_entity_id IS NOT NULL);
CREATE INDEX institution_ext_old_external_id ON dibots_ext.institution_ext USING btree (previous_external_id) WHERE (previous_external_id IS NOT NULL);
CREATE INDEX institution_ext_old_institution_type ON dibots_ext.institution_ext USING btree (previous_institution_type) WHERE (previous_institution_type IS NOT NULL);

set schema 'dibots_ext';
--drop sequence institution_ext_seq;
CREATE SEQUENCE institution_ext_seq increment by -1 maxvalue -1 start with -1 owned by dibots_ext.institution_ext.external_id;
set schema 'public';

select * from dibots_ext.institution_ext

-- sample insertion
insert into dibots_ext.institution_ext (external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
values (nextval('dibots_ext.institution_ext_seq'), 'INST', 'TEST', 'TEST', 'MYS', 'MYS', 'GB', true, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei')


-- insert distinct record from bursa_cs_identity into dibots_ext.institution_ex

select min(id), ic, dbt_entity_id, external_id, account_name, count(*) from bursa_cs_identity
group by ic, dbt_entity_id, external_id, account_name
order by account_name

select min(id), account_name, count(*) from bursa_cs_identity
group by account_name
order by account_name asc

select * from bursa_cs_identity where ic is null and dbt_entity_id is null and external_id is null

--drop table distinct_bursa_cs_identity;
create temp table distinct_bursa_cs_identity (
id int,
ic text,
dbt_entity_id uuid,
external_id int8,
account_name text,
entity_type text,
remark text
);

select * from distinct_bursa_cs_identity --where entity_type is null;

insert into distinct_bursa_cs_identity
select min(id), ic, dbt_entity_id, external_id, account_name from bursa_cs_identity
group by ic, dbt_entity_id, external_id, account_name;

select * from distinct_bursa_cs_identity a, dibots_ext.company_profile b
where a.dbt_entity_id = b.dbt_entity_id and a.entity_type is null

update distinct_bursa_cs_identity a
set entity_type = 'COMPANY'
from dibots_ext.company_profile b
where a.dbt_entity_id = b.dbt_entity_id and a.entity_type is null;

select * from distinct_bursa_cs_identity a, dibots_ext.person_profile b
where a.dbt_entity_id = b.dbt_entity_id and a.entity_type is null

update distinct_bursa_cs_identity a
set entity_type = 'PERSON'
from dibots_ext.person_profile b
where a.dbt_entity_id = b.dbt_entity_id and a.entity_type is null;

update distinct_bursa_cs_identity a
set entity_type = 'COMPANY'
where entity_type is null;


select account_name from distinct_bursa_cs_identity
group by account_name having count(*) > 1

-- comp with no dbt_entity_id [25]
select * from distinct_bursa_cs_identity where dbt_entity_id is null and length(ic) <> 12;

--update distinct_bursa_cs_identity
set entity_type = 'PERSON'
where id in (433, 504, 1138, 1165, 1424, 1526)

--update distinct_bursa_cs_identity
set entity_type = 'COMPANY'
where dbt_entity_id is null and length(ic) <> 12 and entity_type is null;

insert into dibots_ext.institution_ext (external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select nextval('dibots_ext.institution_ext_seq'), entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is null and length(ic) <> 12;

-- person with no dbt_entity_id [132]
select * from distinct_bursa_cs_identity where dbt_entity_id is null and length(ic) = 12;

--update distinct_bursa_cs_identity
set entity_type = 'PERSON'
where dbt_entity_id is null and length(ic) = 12;

insert into dibots_ext.institution_ext (external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select nextval('dibots_ext.institution_ext_seq'), entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is null and length(ic) = 12;

-- person with dbt_entity_id [270]
select * from distinct_bursa_cs_identity where dbt_entity_id is not null and length(ic) = 12

--update distinct_bursa_cs_identity
set entity_type = 'COMPANY'
where id in (1294, 1373, 1393, 1759, 1764, 431)

--update distinct_bursa_cs_identity
set entity_type = 'PERSON'
where dbt_entity_id is not null and length(ic) = 12 and entity_type is null;

insert into dibots_ext.institution_ext (dbt_entity_id, external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select dbt_entity_id, external_id, entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is not null and length(ic) = 12;

-- company with dbt_entity_id [66]
select * from distinct_bursa_cs_identity where dbt_entity_id is not null and length(ic) <> 12

--update distinct_bursa_cs_identity
set entity_type = 'PERSON'
where id in (134, 419, 1357)

--update distinct_bursa_cs_identity
set entity_type = 'COMPANY'
where dbt_entity_id is not null and length(ic) <> 12 and entity_type is null;

insert into dibots_ext.institution_ext (dbt_entity_id, external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select dbt_entity_id, external_id, entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is not null and length(ic) <> 12

-- entity with no dbt_entity_id and no ic, need manual checking [11]
select * from distinct_bursa_cs_identity where dbt_entity_id is null and ic is null

--update distinct_bursa_cs_identity
set entity_type = 'PERSON'
where id in (1273, 916, 1719)

--update distinct_bursa_cs_identity
set entity_type = 'COMPANY'
where dbt_entity_id is null and ic is null and entity_type is null;

insert into dibots_ext.institution_ext (external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select nextval('dibots_ext.institution_ext_seq'), entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is null and ic is null

-- entity with dbt_entity_id but no ic, need manual checking [9]
select * from distinct_bursa_cs_identity where dbt_entity_id is not null and ic is null

--update distinct_bursa_cs_identity
set entity_type = 'COMPANY'
where dbt_entity_id is not null and ic is null

insert into dibots_ext.institution_ext (external_id, institution_type, institution_name, reported_institution_name, country_of_source, country_of_incorporation, language, is_listed, active, comp_status, 
comp_status_desc, is_sanctioned, remarks, wvb_handling_code, wvb_last_update_dtime, created_dtime, created_by)
select nextval('dibots_ext.institution_ext_seq'), entity_type, account_name, account_name, 'MYS', 'MYS', 'GB', false, true, null, null, false, null, 1, '1900-01-01 00:00', now(), 'kangwei'
from distinct_bursa_cs_identity 
where dbt_entity_id is not null and ic is null;

-- Update on bursa_cs_identity for the new dbt_entity_id generated
select * from distinct_bursa_cs_identity where dbt_entity_id is null;

select a.account_name, b.institution_name, b.dbt_entity_id, b.external_id from distinct_bursa_cs_identity a, dibots_ext.institution_ext b
where a.account_name = b.institution_name and a.dbt_entity_id is null
--group by a.account_name, b.institution_name, b.dbt_entity_id, b.external_id having count(*) > 1

--update distinct_bursa_cs_identity a
set
dbt_entity_id = b.dbt_entity_id,
external_id = b.external_id,
entity_type = b.institution_type
from dibots_ext.institution_ext b
where a.account_name = b.institution_name and a.dbt_entity_id is null;

select * from distinct_bursa_cs_identity where dbt_entity_id is null;

select a.account_name, b.account_name, a.dbt_entity_id, a.external_id from distinct_bursa_cs_identity a, bursa_cs_identity b
where a.account_name = b.account_name and b.dbt_entity_id is null;

update bursa_cs_identity a
set
dbt_entity_id = b.dbt_entity_id,
external_id = b.external_id 
from distinct_bursa_cs_identity b
where a.account_name = b.account_name and a.dbt_entity_id is null;


-- Get the remark for relationship

select * from dibots_ext.group_relationship

create unique index on dibots_ext.group_relationship (group_entity_id, dbt_entity_id, remarks);

select * from dibots_ext.group_entity_master

select * from bursa_cs_identity a, distinct_bursa_cs_identity b where
a.account_name = b.account_name --and a.remark is not null

select * from distinct_bursa_cs_identity where remark is null

update distinct_bursa_cs_identity a
set
remark = b.remark
from bursa_cs_identity b
where a.account_name = b.account_name and b.remark is not null;

select c.dbt_entity_id as group_entity_id, a.entity_type, a.dbt_entity_id, a.external_id, a.account_name, a.remark, now(), 'kangwei', 'bursa'
from distinct_bursa_cs_identity a, bursa_cs_raw b, dibots_ext.group_entity_master c
where a.id = b.id and b.comp_group = c.group_name --and a.remark is not null;

insert into dibots_ext.group_relationship (group_entity_id, entity_type, dbt_entity_id, external_id, entity_name, remarks, created_dtime, created_by, data_source)
select c.dbt_entity_id as group_entity_id, a.entity_type, a.dbt_entity_id, a.external_id, a.account_name, a.remark, now(), 'kangwei', 'bursa'
from distinct_bursa_cs_identity a, bursa_cs_raw b, dibots_ext.group_entity_master c
where a.id = b.id and b.comp_group = c.group_name --and a.remark is null;
on conflict do nothing;

select * from dibots_ext.group_relationship;

select group_entity_id, dbt_entity_id, count(*) from dibots_ext.group_relationship
group by group_entity_id, dbt_entity_id

select * from dibots_ext.group_relationship where group_entity_id = 'faa4bbd7-d0c8-4312-a475-2d08c31c9ea2' and dbt_entity_id = 'de047507-38a1-4d88-98dd-53fc77029013'

-- ENITTY_CDS_ACC table
--drop table dibots_ext.entity_cds_acc;
create table dibots_ext.entity_cds_acc (
id int generated by default as identity,
cds_acc text,
entity_dbt_id uuid,
entity_ext_id int8,
entity_name text,
broker_dbt_id uuid,
broker_ext_id int8,
broker_name text,
acc_type text,
nom_dbt_id uuid,
nom_ext_id int8,
nom_name text
);

select * from dibots_ext.entity_cds_acc;

select * from dibots_ext.broker_profile

insert into dibots_ext.entity_cds_acc (cds_acc, entity_dbt_id, entity_ext_id, entity_name, broker_name, acc_type, nom_dbt_id, nom_ext_id, nom_name)
select b.cds_acc, a.dbt_entity_id, a.external_id, a.account_name, b.broker, b.cds_acc_type, b.nom_dbt_entity_id, b.nom_ext_id, a.remark from distinct_bursa_cs_identity a, 
(select dbt_entity_id, btrim(cds_account) as cds_acc, broker, nom_acc_name, nom_dbt_entity_id, nom_ext_id, cds_acc_type, count(*) from bursa_cs_identity 
where cds_account is not null
group by dbt_entity_id, btrim(cds_account), broker, nom_acc_name, nom_dbt_entity_id, nom_ext_id,cds_acc_type)b
where a.dbt_entity_id = b.dbt_entity_id


update dibots_ext.entity_cds_acc a
set
broker_dbt_id = dbt_entity_id,
broker_ext_id = external_id
from dibots_ext.broker_profile b
where a.broker_name = b.participant_name;


-- update bursa_cs_address

select * from bursa_cs_address

select a.account_name, b.account_name, a.dbt_entity_id, a.external_id, b.dbt_entity_id, b.external_id from bursa_cs_address a, bursa_cs_identity b
where a.account_name = b.account_name and a.dbt_entity_id is null

update bursa_cs_address a
set
dbt_entity_id = b.dbt_entity_id,
external_id = b.external_id
from bursa_cs_identity b
where a.account_name = b.account_name and a.dbt_entity_id is null;

select * from bursa_cs_address where btrim(address) = ''

select * from bursa_cs_address where btrim(postcode) = ''

update bursa_cs_address
set postcode = null
where btrim(postcode) = ''

select * from bursa_cs_address where btrim(city) = ''

update bursa_cs_address
set city = null
where btrim(city) = '';

select * from bursa_cs_address where btrim(state) = ''

update bursa_cs_address
set state = null
where btrim(state) = ''

select * from bursa_cs_address where btrim(country) = ''

update bursa_cs_address
set country = null
where btrim(country) = ''

select * from bursa_cs_address where country is null

update bursa_cs_address
set country = 'MYS'
where country is null;

-- insert into address_entity_master

select id, concat(btrim(regexp_replace(address_line_1, '[^A-Za-z0-9]', '', 'g')), ' ', btrim(regexp_replace(address_line_2, '[^A-Za-z0-9]', '', 'g')), ' ', 
btrim(regexp_replace(address_line_3, '[^A-Za-z0-9]', '', 'g')), ' ', btrim(regexp_replace(address_line_4, '[^A-Za-z0-9]', '', 'g'))) from dibots_ext.address_entity_master

select regexp_replace(address, '[^A-Za-z0-9]', '', 'g') from bursa_cs_address

-- check if there's similar address in address_entity_master

select * from
(select id, concat(btrim(regexp_replace(address_line_1, '[^A-Za-z0-9]', '', 'g')), ' ', btrim(regexp_replace(address_line_2, '[^A-Za-z0-9]', '', 'g')), ' ', 
btrim(regexp_replace(address_line_3, '[^A-Za-z0-9]', '', 'g')), ' ', btrim(regexp_replace(address_line_4, '[^A-Za-z0-9]', '', 'g'))) as address_line from dibots_ext.address_entity_master) a,
(select regexp_replace(address, '[^A-Za-z0-9]', '', 'g') as address_line from bursa_cs_address) b
where a.address_line = b.address_line

--drop table tmp_bursa_address;
create temp table tmp_bursa_address (
id int generated by default as identity,
account_name text,
ic text,
dbt_entity_id uuid,
external_id bigint,
address_line text,
deleted bool default false,
exists bool default false,
postcode text,
city text,
state text,
country text,
cleansed_address text
);

insert into tmp_bursa_address (account_name, ic, dbt_entity_id, external_id, address_line, postcode, city, state, country, cleansed_address)
select account_name, ic, dbt_entity_id, external_id, address, postcode, city, state, country, regexp_replace(address, '[^A-Za-z0-9]', '', 'g') from bursa_cs_address

select * from tmp_bursa_address

select address_line, postcode, city, state, country from tmp_bursa_address a,
(select max(id) as id, cleansed_address from tmp_bursa_address group by cleansed_address) b
where a.id = b.id

select * from dibots_ext.address_entity_master

insert into dibots_ext.address_entity_master (address_line_1, postcode, city, state, country, created_dtime, created_by, data_source)
select address_line, postcode, city, state, country, now(), 'kangwei', 'bursa' from tmp_bursa_address a,
(select max(id) as id, cleansed_address from tmp_bursa_address group by cleansed_address) b
where a.id = b.id

-- insert into person_common_address

select * from dibots_ext.person_common_address

insert into dibots_ext.person_common_address (person_entity_id, address_entity_id, created_dtime, created_by, data_source)
select b.dbt_entity_id, a.dbt_entity_id, now(), 'kangwei', 'bursa'
from dibots_ext.address_entity_master a, bursa_cs_address b
where a.address_line_1 = b.address and b.dbt_entity_id is not null

select * from dibots_ext.address_entity_master where dbt_entity_id = '3eee4d6d-0681-4d81-969b-3bb42a3fbd5f'

select * from bursa_cs_address where dbt_entity_id is null

--===============
-- CAUTION 
--===============
-- PURGING

truncate table dibots_ext.group_entity_master restart identity;

