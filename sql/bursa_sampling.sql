drop table if exists bursa_sampling;
create table bursa_sampling (
director_name varchar(255),
director_nric varchar(255),
director_entity_id uuid,
director_ext_id int,
company_name varchar(255)
);

select * from bursa_sampling;

insert into bursa_sampling (director_name, director_nric, company_name) values ('TNG KEE MENG', '491216015519', 'ELASTOR POLYURETHANE SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('WONG HAN CHOONG', '720525085883', 'ESPRIT CARE SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('PUA KIM KIAN', '581202106777', 'EH IBS SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('JAMALUDIN SHAH BIN ZAINAL', '781027045327', 'E-POWER ENGINEERING SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LEE YIN FAH', '570613105927', 'EXCEL AIRCONDITIONING AND ENGINEER');
insert into bursa_sampling (director_name, director_nric, company_name) values ('KOO KOK TAK', '520704086041', 'EMPOWER DRIVES AND AUTOMATION SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('YAP SENG BOON', '611017085753', 'FIT-LINE ENGINEERING SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LIM FOOH SOON', '660802015639', 'FOOH BENG HEALTH CARE SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('TAN SUAN KEAN', '710903106401', 'FUSE ASIA SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('RAJA AZLAN BIN RAJA SULAIMAN', '641005086537', 'FAQUA BUILD SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('OOI ZIN HENG', 790728085131, 'GAMMA COATING SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('RAMACHANDRAN A/L KALIMUTHU', 600729106459, 'GREEN PANEL PRODUCTS (M) SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LILY WONG @ LEE LEE', 350619715238, 'HH-HOO HONG SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LEE LI KIEN', 741106105424, 'IOS SERVICES SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LAU KING YEW', 691202105421, 'ITECH PLANTATION SOFT SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('LETCHUMANAN GOMEZ', 701026085949, 'IRVING RESOURCES SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('MOK WAI KEAT', 701223105961, 'IN FUTURE PRECISION SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('TAN LENG KEE', 721021105734, 'INFUSO SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('NG SIEW LENG', 620220105160, 'INSPIROS INTERNATIONAL SDN BHD');
insert into bursa_sampling (director_name, director_nric, company_name) values ('TAN SAU NGOR', 580703105954, 'JL FACILITIES MANAGEMENT SDN BHD');


select * from bursa_sampling a, dibots_v2.entity_identifier ei, dibots_v2.entity_master em
where a.director_nric = ei.identifier and ei.identifier_type = 'MK' and ei.dbt_entity_id = em.dbt_entity_id and em.active = true

update bursa_sampling a
set
director_entity_id = ei.dbt_entity_id
from dibots_v2.entity_identifier ei, dibots_v2.entity_master em
where a.director_nric = ei.identifier and ei.identifier_type = 'MK' and ei.dbt_entity_id = em.dbt_entity_id and em.active = true;

update bursa_sampling a
set
director_ext_id = pp.external_id
from dibots_v2.person_profile pp
where a.director_entity_id = pp.dbt_entity_id and pp.wvb_entity_type = 'PERS'

-- currently active directors
select a.director_name, a.director_nric, a.director_entity_id, a.director_ext_id, a.company_name, cpr.company_id, cp.company_name, cpr.role_type, cpr.role_desc, cpr.eff_from_date, cpr.eff_end_date
from bursa_sampling a, dibots_v2.company_person_role cpr, dibots_v2.company_profile cp
where a.director_entity_id = cpr.person_id and cpr.eff_end_date is null and cpr.company_id = cp.dbt_entity_id

-- historical director
select a.director_name, a.director_nric, a.director_entity_id, a.director_ext_id, a.company_name, cpr.company_id, cp.company_name, cpr.role_type, cpr.role_desc, cpr.eff_from_date, cpr.eff_end_date
from bursa_sampling a, dibots_v2.company_person_role cpr, dibots_v2.company_profile cp
where a.director_entity_id = cpr.person_id and cpr.eff_end_date is not null and cpr.company_id = cp.dbt_entity_id

drop table if exists bursa_sampling_director;
create table bursa_sampling_director (
id serial primary key,
person_name varchar(255),
person_nric varchar(255),
person_entity_str varchar(255),
person_entity_id uuid,
person_ext_id int,
company_id_str varchar(255),
company_id uuid,
company_ext_id int,
company_name varchar(255),
role_type varchar(10),
role_desc varchar(255),
eff_from_date_str varchar(255),
eff_end_date_str varchar(255),
eff_from_date date,
eff_end_date date,
latest_fin_date date,
revenue numeric(25,2),
pat numeric(25,2)
);

select * from bursa_sampling_director

update bursa_sampling_director
set
person_entity_id = cast(person_entity_str as uuid),
company_id = cast(company_id_str as uuid),
eff_from_date = cast(eff_from_date_str as date),
eff_end_date = CASE WHEN eff_end_date_str = '' THEN NULL ELSE cast(eff_end_date_str as date) END

alter table bursa_sampling_director drop column person_entity_str, drop column company_id_str, drop column eff_from_date_str, drop column eff_end_date_str;

update bursa_sampling_director a
set company_ext_id = cp.external_id
from dibots_v2.company_profile cp
where a.company_id = cp.dbt_entity_id and cp.wvb_entity_type = 'COMP'

alter table bursa_sampling_director add column wvb_hdr_id int;

update bursa_sampling_director a
set
latest_fin_date = tmp.max_date
from (select a.company_id, a.company_name, max(b.fiscal_period_end_date) as max_date from bursa_sampling_director a, dibots_v2.analyst_hdr b
where a.company_id = b.dbt_entity_id
group by a.company_id, a.company_name) tmp
where a.company_id = tmp.company_id

update bursa_sampling_director a
set
wvb_hdr_id = hdr.wvb_hdr_id
from dibots_v2.analyst_hdr hdr
where a.company_id = hdr.dbt_entity_id and a.latest_fin_date = hdr.fiscal_period_end_date;

update bursa_sampling_director a
set
revenue = calc.numeric_value
from dibots_v2.wvb_calc_item_value calc
where a.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3000

update bursa_sampling_director a
set
pat = calc.numeric_value
from dibots_v2.wvb_calc_item_value calc
where a.wvb_hdr_id = calc.wvb_hdr_id and calc.data_item_id = 3037

select * from bursa_sampling_director 

-- magic
update bursa_sampling_director
set
latest_fin_date = '2018-12-31',
wvb_hdr_id = 55335290
where company_id = '3c687205-70c1-46f8-8083-ce41b3ed8feb'



select * from bursa_sampling_director where eff_end_date is null;