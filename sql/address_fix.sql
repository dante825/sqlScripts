select * from dibots_v2.address_master where country is null and upper(city) like '%PERLIS%';

select * from dibots_v2.address_master where country is null and upper(city) like '%KEDAH%';

select * from dibots_v2.address_master where country is null and upper(city) like '%PINANG%';

select * from dibots_v2.address_master where country is null and upper(city) like '%PERAK%';

select * from dibots_v2.address_master where country is null and upper(city) like '%KELANTAN%';

select * from dibots_v2.address_master where country is null and upper(city) like '%TERENGGANU%';

select * from dibots_v2.address_master where country is null and upper(city) like '%PAHANG%';

select * from dibots_v2.address_master where country is null and upper(city) like '%SELANGOR%';

select * from dibots_v2.address_master where country is null and upper(city) like '%SEMBILAN%';

select * from dibots_v2.address_master where country is null and upper(city) like '%MELAKA%';

select * from dibots_v2.address_master where country is null and upper(city) like '%JOHOR%';

select * from dibots_v2.address_master where country is null and upper(city) like '%SABAH%';

select * from dibots_v2.address_master where country is null and upper(city) like '%SARAWAK%';

select * from dibots_v2.address_master where country is null and upper(city) like '%KUALA LUMPUR%';

select * from dibots_v2.address_master where country is null and upper(city) like '%PUTRAJAYA%';

select * from dibots_v2.address_master where country is null and upper(city) like '%CYBERJAYA%';

select * from dibots_v2.address_master where country is null and upper(city) like '%LABUAN%';

select * from dibots_v2.address_master where country is null and upper(city) like '%FEDERAL TERRITORY%';

select * from dibots_v2.address_master where country is null and upper(city) like '%WILAYAH PERSEKUTU%';

update dibots_v2.address_master
set
country = 'MYS',
modified_dtime = now(),
modified_by = 'kangwei'
where country is null and upper(city) like '%PERLIS%';


select * from dibots_v2.address_master where country = 'MYS' and postcode is not null and length(postcode) = 4 --and postcode <> 'NULL'

--==================
-- Fixing address master null values
--==================

select * from dibots_v2.address_master where lower(btrim(address_line_1)) = 'nil' or lower(btrim(address_line_1)) = 'null' or btrim(lower(address_line_1)) = '' or btrim(lower(address_line_1)) = 'tiada';

update dibots_v2.address_master
set
address_line_1 = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(address_line_1)) = 'nil' or lower(btrim(address_line_1)) = 'null' or btrim(lower(address_line_1)) = '' or btrim(lower(address_line_1)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(address_line_2)) = 'nil' or lower(btrim(address_line_2)) = 'null' or btrim(lower(address_line_2)) = '' or btrim(lower(address_line_2)) = 'tiada';

update dibots_v2.address_master
set
address_line_2 = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(address_line_2)) = 'nil' or lower(btrim(address_line_2)) = 'null' or btrim(lower(address_line_2)) = '' or btrim(lower(address_line_2)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(address_line_3)) = 'nil' or lower(btrim(address_line_3)) = 'null' or btrim(lower(address_line_3)) = '' or btrim(lower(address_line_3)) = 'tiada';

update dibots_v2.address_master
set
address_line_3 = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(address_line_3)) = 'nil' or lower(btrim(address_line_3)) = 'null' or btrim(lower(address_line_3)) = '' or btrim(lower(address_line_3)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(address_line_4)) = 'nil' or lower(btrim(address_line_4)) = 'null' or btrim(lower(address_line_4)) = '' or btrim(lower(address_line_4)) = 'tiada';

update dibots_v2.address_master
set
address_line_4 = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(address_line_4)) = 'nil' or lower(btrim(address_line_4)) = 'null' or btrim(lower(address_line_4)) = '' or btrim(lower(address_line_4)) = 'tiada';


select * from dibots_v2.address_master where btrim(postcode) = 'nil' or btrim(postcode) = 'null' or btrim(postcode) = '' or btrim(lower(postcode)) = 'tiada';

update dibots_v2.address_master
set
postcode = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(postcode)) = 'nil' or lower(btrim(postcode)) = 'null' or btrim(postcode) = '';


select * from dibots_v2.address_master where lower(btrim(raw_address)) = 'nil' or lower(btrim(raw_address)) = 'null' or btrim(lower(raw_address)) = '' or btrim(lower(raw_address)) = 'tiada';

update dibots_v2.address_master
set
raw_address = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(raw_address)) = 'nil' or lower(btrim(raw_address)) = 'null' or btrim(lower(raw_address)) = '' or btrim(lower(raw_address)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(city)) = 'nil' or lower(btrim(city)) = 'null' or btrim(lower(city)) = '' or btrim(lower(city)) = 'tiada';

update dibots_v2.address_master
set
city = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(city)) = 'nil' or lower(btrim(city)) = 'null' or btrim(lower(city)) = '' or btrim(lower(city)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(state)) = 'nil' or lower(btrim(state)) = 'null' or btrim(lower(state)) = '' or btrim(lower(state)) = 'tiada';

update dibots_v2.address_master
set
state = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(state)) = 'nil' or lower(btrim(state)) = 'null' or btrim(lower(state)) = '' or btrim(lower(state)) = 'tiada';

select * from dibots_v2.address_master where lower(btrim(state_code)) = 'nil' or lower(btrim(state_code)) = 'null' or btrim(lower(state_code)) = '' or btrim(lower(state_code)) = 'tiada';

update dibots_v2.address_master
set
state_code = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(state_code)) = 'nil' or lower(btrim(state_code)) = 'null' or btrim(lower(state_code)) = '' or btrim(lower(state_code)) = 'tiada';


select * from dibots_v2.address_master where lower(btrim(country)) = 'nil' or lower(btrim(country)) = 'null' or btrim(lower(country)) = '' or btrim(lower(country)) = 'tiada';

update dibots_v2.address_master
set
country = null,
modified_by = 'kangwei',
modified_dtime = now()
where lower(btrim(country)) = 'nil' or lower(btrim(country)) = 'null' or btrim(lower(country)) = '' or btrim(lower(country)) = 'tiada';

select * from dibots_v2.address_master where address_line_1 like E'\'%'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, E'\'', '','g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like E'\'%';

select * from dibots_v2.address_master where address_line_2 like E'\'%'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, E'\'', '','g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like E'\'%';

select * from dibots_v2.address_master where address_line_3 like E'\'%'

update dibots_v2.address_master 
set address_line_3 = regexp_replace(address_line_3, E'\'', '','g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_3 like E'\'%';

select * from dibots_v2.address_master where address_line_4 like E'\'%'

update dibots_v2.address_master 
set address_line_4 = regexp_replace(address_line_4, E'\'', '','g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_4 like E'\'%';

-- to balance the single quote '

vacuum (analyze) dibots_v2.address_master;


--==================================
-- Replacing some common shortened words with the correct words
-- Focus on MYS address
--=================================

select * from dibots_v2.address_master where address_line_1 like 'NO %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_1 = regexp_replace(address_line_1, 'NO ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_1 = regexp_replace(address_line_1, 'No ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_1 = regexp_replace(address_line_1, 'no ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no %' and country = 'MYS';


select * from dibots_v2.address_master where address_line_1 like 'NO. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'NO. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'No. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'no. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'NO.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'NO.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'No.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'no.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'NO:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'NO:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'No:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'no:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'NO;%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'NO;', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO;%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No;%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'No;', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No;%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no; %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'no; ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no; %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'NO, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'NO, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'NO, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'No, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'No, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'No, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'no, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'no, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'no, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JLN. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JLN. ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JLN. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JLN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JLN.', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JLN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JLN %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JLN ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JLN %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JLN,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JLN,', ', JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JLN,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JLN%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JLN', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JLN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% JLN. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' JLN. ', ' JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%JLN. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,jln %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',jln ', ', jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,jln %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%JLN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'JLN', 'JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%JLN%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%jln%'-- and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'jln', 'jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%jln%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,JALAN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JALAN.', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JALAN.%' --and country = 'MYS';


select * from dibots_v2.address_master where address_line_1 like '%,JALAN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',JALAN', ', JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,JALAN%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%JALAN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'JALAN. ', 'JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%JALAN. %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%JALAN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'JALAN.', 'JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%JALAN.%' --and country = 'MYS';


select * from dibots_v2.address_master where address_line_1 like '%,Jalan%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',Jalan', ', Jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,Jalan%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,jalan%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',jalan', ', jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,jalan%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%jalan. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'jalan. ', 'jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%jalan. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%jalan.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'jalan.', 'jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%jalan.%' and country = 'MYS';

-- add a comma
select * from dibots_v2.address_master where address_line_1 like '% JALAN %' and address_line_1 not like '%, JALAN %' and address_line_1 not like '%OFF JALAN%'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' JALAN ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% JALAN %' and address_line_1 not like '%, JALAN %' --and country = 'MYS';

select * from dibots_v2.address_master where lower(address_line_1) like '%jln%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%,jalan%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%jalan.%' --and country = 'MYS'

select * from dibots_v2.address_master where address_line_1 like '% JALAN %' and address_line_1 not like '%, JALAN %' and address_line_1 not like '%OFF JALAN%'

select * from dibots_v2.address_master where lower(address_line_1) like '%bkt%'

select * from dibots_v2.address_master where lower(address_line_1) like '%lrg%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%flr%'

select * from dibots_v2.address_master where lower(address_line_1) like '%bgn%'

select * from dibots_v2.address_master where lower(address_line_1) like '%sek.%'


--=========

select * from dibots_v2.address_master where address_line_2 like 'NO %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_2 = regexp_replace(address_line_2, 'NO ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_2 = regexp_replace(address_line_2, 'No ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no %' and country = 'MYS';

update dibots_v2.address_master 
set 
address_line_2 = regexp_replace(address_line_2, 'no ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no %' and country = 'MYS';


select * from dibots_v2.address_master where address_line_2 like 'NO. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'NO. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'No. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no. %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'no. ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'NO.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'NO.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'No.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no.%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'no.', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'NO:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'NO:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'No:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no:%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'no:', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no:%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'NO;%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'NO;', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO;%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No;%' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'No;', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No;%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no; %' and country = 'MYS';

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'no; ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no; %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'NO, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'NO, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'NO, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'No, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'No, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'No, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'no, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'no, ', '', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'no, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JLN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JLN. ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JLN. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JLN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JLN.', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JLN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JLN %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JLN ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JLN %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JLN,%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JLN,', ', JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JLN,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JLN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JLN', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JLN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% JLN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' JLN. ', ' JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% JLN. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,jln %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',jln ', ', jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,jln %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%JLN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'JLN', 'JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%JLN%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%jln%'-- and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'jln', 'jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%jln%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,JALAN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JALAN.', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JALAN.%' --and country = 'MYS';


select * from dibots_v2.address_master where address_line_2 like '%,JALAN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',JALAN', ', JALAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,JALAN%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%JALAN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'JALAN. ', 'JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%JALAN. %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%JALAN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'JALAN.', 'JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%JALAN.%' --and country = 'MYS';


select * from dibots_v2.address_master where address_line_2 like '%,Jalan%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',Jalan', ', Jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,Jalan%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,jalan%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',jalan', ', jalan', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,jalan%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%jalan. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'jalan. ', 'jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%jalan. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%jalan.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'jalan.', 'jalan ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%jalan.%' and country = 'MYS';

-- add a comma
select * from dibots_v2.address_master where address_line_2 like '% JALAN %' and address_line_2 not like '%, JALAN %' and address_line_2 not like '%OFF JALAN%'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' JALAN ', ', JALAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% JALAN %' and address_line_2 not like '%, JALAN %' --and country = 'MYS';

select * from dibots_v2.address_master where lower(address_line_2) like '%jln%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%,jalan%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%jalan.%' --and country = 'MYS'


--======================

select * from dibots_v2.address_master where address_line_1 like '%TMN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'TMN. ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%TMN. %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%TMN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'TMN.', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%TMN.%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%TMN %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'TMN ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%TMN %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% TMN%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' TMN', ' TAMAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% TMN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,TMN,%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',TMN,', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,TMN,%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,TMN%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',TMN', ', TAMAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,TMN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,TAMAN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',TAMAN.', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%, TAMAN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ', TAMAN.', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%, TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%TAMAN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'TAMAN.', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,tmn.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',tmn.', ', taman ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,tmn.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%, tmn%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ', tmn', ', taman', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%, tmn%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%tmn.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'tmn.', 'taman', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%tmn.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%tmn %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'tmn ', 'taman ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%tmn %' and country = 'MYS';


select * from dibots_v2.address_master where lower(address_line_1) like '%tmn%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%tmn %' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%tmn,%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%tmn.%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%taman,%' and country = 'MYS'

--==========

select * from dibots_v2.address_master where address_line_2 like '%TMN. %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TMN. ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TMN. %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%TMN.%'-- and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TMN.', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TMN.%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%TMN %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TMN ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TMN %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% TMN%'-- and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' TMN', ' TAMAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% TMN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,TMN,%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',TMN,', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,TMN,%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,TMN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',TMN', ', TAMAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,TMN%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%TMN, %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TMN, ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TMN, %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%TMN,%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TMN,', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TMN,%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,TAMAN.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',TAMAN.', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,TAMAN %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',TAMAN ', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,TAMAN %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,TAMAN%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',TAMAN', ', TAMAN', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,TAMAN%' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%, TAMAN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ', TAMAN.', ', TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%, TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%TAMAN. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TAMAN. ', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TAMAN. %' and country = 'MYS';


select * from dibots_v2.address_master where address_line_2 like '%TAMAN.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'TAMAN.', 'TAMAN ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%TAMAN.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,tmn.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',tmn.', ', taman ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,tmn.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%, tmn%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ', tmn', ', taman', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%, tmn%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%tmn.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'tmn.', 'taman', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%tmn.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%tmn %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'tmn ', 'taman ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%tmn %' --and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,taman %' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',taman ', ', taman ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,taman %' --and country = 'MYS';



select * from dibots_v2.address_master where lower(address_line_2) like '%tmn%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%tmn %' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%tmn,%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%,taman%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%tmn.%' --and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%taman.%' --and country = 'MYS'

--=========

select * from dibots_v2.address_master where address_line_1 like '% LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LRG. ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',LRG. ', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',LRG ', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,LRG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',LRG.', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,LRG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',LRG,', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,LRG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% LRG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LRG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LRG ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%.LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, '.LRG. ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%.LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG. ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'LRG.%' --and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG.', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like 'LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like 'LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%.LRG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, '.LRG', ' LORONG', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%.LRG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%LRG, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG, ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%LRG, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%LRG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG,', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%LRG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%LRG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, 'LRG', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%LRG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% lrg %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' lrg ', ' lorong ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% lrg %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% LORONG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LORONG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LORONG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% LORONG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LORONG,', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LORONG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '% LORONG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ' LORONG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '% LORONG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,LORONG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',LORONG', ', LORONG', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,LORONG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_1 like '%,lorong%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_1 = regexp_replace(address_line_1, ',lorong', ', lorong', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_1 like '%,lorong%' and country = 'MYS';

select * from dibots_v2.address_master where lower(address_line_1) like '%lrg%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '% lorong.%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%,lorong%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_1) like '%lorong.%' and country = 'MYS'

--==========

select * from dibots_v2.address_master where address_line_2 like '% LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LRG. ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',LRG. ', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',LRG ', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,LRG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',LRG.', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,LRG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',LRG,', ', LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,LRG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% LRG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LRG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LRG ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%.LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, '.LRG. ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%.LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%LRG. %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG. ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%LRG. %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'LRG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG.', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'LRG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like 'LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like 'LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%.LRG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, '.LRG', ' LORONG', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%.LRG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%LRG, %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG, ', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%LRG, %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%LRG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG,', 'LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%LRG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%LRG %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG ', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%LRG %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%LRG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, 'LRG', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%LRG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% lrg %' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' lrg ', ' lorong ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% lrg %' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% LORONG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LORONG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LORONG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% LORONG,%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LORONG,', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LORONG,%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '% LORONG.%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ' LORONG.', ' LORONG ', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '% LORONG.%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,LORONG%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',LORONG', ', LORONG', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,LORONG%' and country = 'MYS';

select * from dibots_v2.address_master where address_line_2 like '%,lorong%' and country = 'MYS'

update dibots_v2.address_master 
set address_line_2 = regexp_replace(address_line_2, ',lorong', ', lorong', 'g'),
modified_dtime = now(),
modified_by = 'kangwei'
where address_line_2 like '%,lorong%' and country = 'MYS';

select * from dibots_v2.address_master where lower(address_line_2) like '%lrg%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '% lorong.%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%,lorong%' and country = 'MYS'

select * from dibots_v2.address_master where lower(address_line_2) like '%lorong.%' and country = 'MYS'

--=======

select count(*) from dibots_v2.address_master where modified_dtime::date = '2022-02-07' and modified_by = 'kangwei'

VACUUM (ANALYZE) dibots_v2.address_master;
