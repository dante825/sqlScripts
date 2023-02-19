-- a table to keep track of the count

create table incr_table_count (
id serial primary key,
table_name varchar(255),
count int,
created_by varchar,
created_dtime timestamp with time zone
);

select * from incr_table_count;

insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.advisor', (select count(*) from dibots_v2.advisor), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.advisor', (select count(*) from wvb_clone.advisor), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.company_advisor', (select count(*) from dibots_v2.company_advisor), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.company_advisor', (select count(*) from wvb_clone.company_advisor), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.cross_ref', (select count(*) from dibots_v2.cross_ref), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.cross_ref', (select count(*) from wvb_clone.cross_ref), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.equity_security', (select count(*) from dibots_v2.equity_security), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.equity_security', (select count(*) from wvb_clone.equity_security), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.equity_security_owner', (select count(*) from dibots_v2.equity_security_owner), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.equity_security_owner', (select count(*) from wvb_clone.equity_security_owner), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.company_person_role', (select count(*) from dibots_v2.company_person_role), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.company_person_role', (select count(*) from wvb_clone.company_person_role), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.company_person_role_sal_hdr', (select count(*) from dibots_v2.company_person_role_sal_hdr), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.company_person_role_sal_hdr', (select count(*) from wvb_clone.company_person_role_sal_hdr), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('dibots_v2.company_person_role_sal_val', (select count(*) from dibots_v2.company_person_role_sal_val), 'kangwei', now());
insert into incr_table_count(table_name, count, created_by, created_dtime) values ('wvb_clone.company_person_role_sal_value', (select count(*) from wvb_clone.company_person_role_sal_value), 'kangwei', now());
