create table tmp_exchange_director (
stock_code varchar,
company_name varchar,
title varchar,
director_name varchar,
app_date varchar,
designation varchar,
pst_app_date varchar,
pst_resign_date varchar,
board varchar,
sector varchar,
gender varchar,
nationality varchar,
birth_date varchar,
ic varchar,
id varchar,
top_100 varchar
);

select * from tmp_exchange_director;

drop table dibots_v2.exchange_director;
create table dibots_v2.exchange_director (
id varchar primary key,
stock_code varchar,
company_name varchar,
company_id uuid,
company_ext_id int,
title varchar,
director_name varchar,
person_id uuid,
person_ext_id int,
app_date date,
designation varchar,
past_appointed_date date,
past_resigned_date date,
board varchar,
sector varchar,
gender varchar,
nationality varchar,
birth_date date,
ic_no varchar,
top_100 bool default false
);

insert into dibots_v2.exchange_director (id, stock_code, company_name, title, director_name, app_date, designation, past_appointed_date, past_resigned_date, board, sector, gender, nationality,
birth_date, ic_no, top_100)
select id, stock_code, company_name, title, director_name, cast(app_date as date), designation, cast(pst_app_date as date), cast(pst_resign_date as date), board, sector, gender, nationality,
cast(birth_date as date), ic, CASE WHEN top_100 = 'Y' THEN TRUE ELSE FALSE END
from tmp_exchange_director;

select * from dibots_v2.exchange_director where title = ' '

select * from dibots_v2.exchange_director where gender = ''

select * from dibots_v2.exchange_director where nationality = ''

select * from dibots_v2.exchange_director where ic_no = ''

update dibots_v2.exchange_director
set ic_no = null
where ic_no = ' '


select count(distinct(stock_code)) from dibots_v2.exchange_director;

select * from dibots_v2.exchange_director;

-- update the company_id and external_id
update dibots_v2.exchange_director ed
set
company_id = cp.dbt_entity_id,
company_ext_id = cp.external_id
from 
dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ed.stock_code = ei.identifier and ei.identifier_type = 'STOCKEX' and ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_incorporation = 'MYS' and ei.eff_end_date is null

-- country_of_domicile = 'MYS'
update dibots_v2.exchange_director ed
set
company_id = cp.dbt_entity_id,
company_ext_id = cp.external_id
from 
dibots_v2.entity_identifier ei, dibots_v2.company_profile cp
where ed.company_id is null and ed.stock_code = ei.identifier and ei.identifier_type = 'STOCKEX' and ei.dbt_entity_id = cp.dbt_entity_id and cp.country_of_domicile = 'MYS' and ei.eff_end_date is null

-- some need to be handled manually
select * from dibots_v2.exchange_director where company_id is null;

select * from dibots_v2.company_profile where dbt_entity_id in (
select dbt_entity_id from dibots_v2.entity_identifier where identifier = '5959' and identifier_type = 'STOCKEX')

update dibots_v2.exchange_director ed set company_id = '24c9448b-d377-4060-acdb-67bd4e184ba0', company_ext_id = 6149
where ed.stock_code = '5090' and company_name = 'MEDIA CHINESE INTERNATIONAL LT'

update dibots_v2.exchange_director ed set company_id = 'af6413b9-b3c4-4915-8982-99302f8acb10', company_ext_id = 58849
where ed.stock_code = '5156' and company_name = 'XIDELANG HOLDINGS LTD'

update dibots_v2.exchange_director ed set company_id = '6c542ec9-bdcd-4777-affe-4c153dcead57', company_ext_id = 64163
where ed.stock_code = '5188' and company_name = 'CHINA OUHUA WINERY HLDGS LTD'

update dibots_v2.exchange_director ed set company_id = '017165cc-698e-4091-9069-f3dbcceafb0e', company_ext_id = 61630
where ed.stock_code = '5172' and company_name = 'K-STAR SPORTS LIMITED'

update dibots_v2.exchange_director ed set company_id = '51f613ce-34e0-4642-97ca-074e0bba66c8', company_ext_id = 67013
where ed.stock_code = '5187' and company_name = 'HB GLOBAL LIMITED'

update dibots_v2.exchange_director ed set company_id = '51ece583-0576-498a-b2c7-7dbf779b9c13', company_ext_id = 2650630
where ed.stock_code = '5229' and company_name = 'CHINA AUTOMOBILE PARTS HLD LTD'

update dibots_v2.exchange_director ed set company_id = '588e1356-ee96-4425-9fb0-2dd8c6f0f573', company_ext_id = 7534
where ed.stock_code = '5959' and company_name = 'AMVERTON BERHAD'

-- fix the symbols in the title
update dibots_v2.exchange_director ed
set
title = REPLACE(title, '&apos;', '')

-- fix the symbols in director_name
update dibots_v2.exchange_director ed
set
director_name = REPLACE(director_name, '&apos;', '')


-- fix the symbols in sector
update dibots_v2.exchange_director ed
set
sector = REPLACE(sector, '&amp;', '&')


-- Getting the person id by matching the company_id in company_person_role and exact matching the name, exact match: 6215
update dibots_v2.exchange_director ed
set
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g')

-- checking those unmatched

select * from dibots_v2.exchange_director where person_id is null;


select cpr.company_id, cpr.person_id, pp.external_id, pp.fullname
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and cpr.company_id = '49badd86-19f0-4d54-971b-feb23809f999'

-- get 2 list to do the fuzzy matching with partial_token_set_ratio
select id, company_id, company_ext_id, director_name from dibots_v2.exchange_director where person_id is null;

select distinct cpr.company_id, cpr.person_id, pp.external_id, pp.fullname  from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and cpr.company_id in (select distinct(company_id) from dibots_v2.exchange_director where person_id is null);

-- based on the 2 list, did a token_sort_ratio with fuzzywuzzy, the result is in tmp_cpr_director
update dibots_v2.exchange_director ed
set
person_id = cast(tmp.person_id as uuid)
from tmp_cpr_director tmp
where ed.id = tmp.id

update dibots_v2.exchange_director ed
set
person_ext_id = pp.external_id
from dibots_v2.person_profile pp
where ed.person_id = pp.dbt_entity_id

select count(*) from dibots_v2.exchange_director where person_id is not null; -- 14981

-- after fuzzy matching check again


-- update the person_id and external_id based on the designation or role type with company_person_role table REDUNDANT!
update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('DIR', 'MANDIR', 'OUTDIR', 'DIR2') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' 
and ed.designation IN ('DIRECTOR', 'EXECUTIVE DIRECTOR', 'MANAGING DIRECTOR', 'NON-EXECUTIVE DIRECTOR', 'ALTERNATE DIRECTOR', 'DEPUTY MANAGING DIRECTOR', 'INDEPENDENT DIRECTOR', 'GROUP MANAGING DIRECTOR', 'JOINT MANAGING DIRECTOR',
'GROUP EXECUTIVE DIRECTOR', 'CHIEF BUSINESS DEV. OFFICER', 'DEPUTY CHIEF OPERATING OFFICER', 'MEMBER OF AUDIT COMMITTEE') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') AND ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type = 'COB' and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('CHAIRMAN', 'NON-EXECUTIVE CHAIRMAN', 'EXECUTIVE CHAIRMAN', 'CO-CHAIRMAN') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') AND ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('VCHAIR', 'CEC') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('VICE CHAIRMAN', 'EXECUTIVE DEPUTY CHAIRMAN', 'DEPUTY CHAIRMAN', 'CO-CHAIRMAN') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') AND ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('CEO', 'VCEO') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and 
ed.designation IN ('CHIEF EXECUTIVE OFFICER', 'CHIEF EXECUTIVE DIRECTOR', 'GROUP CHIEF EXECUTIVE OFFICER', 'DEPUTY CHIEF EXECUTIVE OFFICER', 'CHIEF BUSINESS DEV. OFFICER') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type = 'PRES' and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('PRESIDENT') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type = 'COPS' and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('CHIEF OPERATING OFFICER', 'DEPUTY CHIEF OPERATING OFFICER') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type = 'CFO' and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('CHIEF FINANCIAL OFFICER', 'CHIEF FINANCE DIRECTOR') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('EXECVP', 'VCEO', 'SRVP') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('EXECUTIVE VICE PRESIDENT') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('VP') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('VICE PRESIDENT') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('CTO') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('CHIEF TECHNOLOGY OFFICER') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

update dibots_v2.exchange_director ed
set 
person_id = pp.dbt_entity_id,
person_ext_id = pp.external_id
from dibots_v2.company_person_role cpr, dibots_v2.person_profile pp
where ed.company_id = cpr.company_id and cpr.role_type in ('AUDITOR') and cpr.person_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS' and ed.designation IN ('MEMBER OF AUDIT COMMITTEE') AND
regexp_replace(lower(pp.fullname), '[^A-Za-z0-9]', '', 'g') = regexp_replace(lower(ed.director_name), '[^A-Za-z0-9]', '', 'g') and ed.person_id is null;

select * from dibots_v2.exchange_director where person_id is null and designation not in ('DIRECTOR', 'EXECUTIVE DIRECTOR', 'MANAGING DIRECTOR', 'NON-EXECUTIVE DIRECTOR', 'ALTERNATE DIRECTOR',
'CHAIRMAN', 'NON-EXECUTIVE CHAIRMAN', 'CHIEF EXECUTIVE OFFICER','PRESIDENT', 'DEPUTY MANAGING DIRECTOR', 'CHIEF OPERATING OFFICER', 'VICE CHAIRMAN', 'EXECUTIVE DEPUTY CHAIRMAN', 'EXECUTIVE CHAIRMAN',
'CHIEF FINANCIAL OFFICER', 'CHIEF EXECUTIVE DIRECTOR', 'DEPUTY CHAIRMAN', 'GROUP CHIEF EXECUTIVE OFFICER', 'DEPUTY CHIEF EXECUTIVE OFFICER', 'INDEPENDENT DIRECTOR', 'GROUP MANAGING DIRECTOR', 'EXECUTIVE VICE PRESIDENT',
'JOINT MANAGING DIRECTOR', 'CO-CHAIRMAN', 'CHIEF FINANCE DIRECTOR', 'GROUP EXECUTIVE DIRECTOR', 'CHIEF BUSINESS DEV. OFFICER', 'CHIEF TECHNOLOGY OFFICER', 'DEPUTY CHIEF OPERATING OFFICER', 'VICE PRESIDENT', 
'MEMBER OF AUDIT COMMITTEE')
