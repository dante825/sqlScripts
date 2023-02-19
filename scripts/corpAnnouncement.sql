--drop table if exists dibots_v2.wvb_news_item_body;
create table dibots_v2.wvb_news_item_body (
item_perm_id numeric primary key,
item_content text,
item_language varchar,
created_dtime TIMESTAMP WITH TIME ZONE NOT NULL,
created_by VARCHAR(100) NOT NULL,
modified_dtime TIMESTAMP WITH TIME ZONE,
modified_by VARCHAR(100)
);

select count(*) from dibots_v2.wvb_news_item_body;

select * from dibots_v2.wvb_news_item_body order by item_perm_id desc;

select count(*) from wvb_news_item_body;

--truncate table wvb_news_item_body restart identity;

-- insert into news_body
insert into dibots_v2.wvb_news_item_body (item_perm_id, item_content, item_language, created_dtime, created_by) 
select item_perm_id, item_content, item_language, now(), 'kangwei' from wvb_news_item_body
ON CONFLICT DO NOTHING

--drop table if exists dibots_v2.wvb_news_item;
create table dibots_v2.wvb_news_item (
item_perm_id numeric,
wvb_number varchar,
item_heading varchar,
distributor_perm_id numeric,
format_perm_id numeric,
item_language varchar,
type_perm_id numeric,
topic_perm_id numeric,
item_publish_time timestamp with time zone,
item_gmt_time timestamp with time zone,
item_received_time timestamp with time zone,
company_name text,
ticker varchar(100),
mic varchar(100),
isin varchar(100),
item_url varchar,
item_signature text,
item_status numeric,
item_attached numeric,
item_news_id varchar,
dtime_approved timestamp with time zone,
dtime_created timestamp with time zone,
dtime_last_changed timestamp with time zone,
created_dtime timestamp with time zone not null,
created_by varchar(100) not null,
modified_time timestamp with time zone,
modified_by varchar(100),
primary key(item_perm_id, item_language)
);

-- insert into news_item
insert into dibots_v2.wvb_news_item (item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, 
company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, created_dtime, created_by)
select item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, company_name, ticker, mic, isin, item_url,
item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, now(), 'kangwei' from wvb_news_item;

select string_to_array(company_perm_id_list, ',')::numeric[] from wvb_news_item

--truncate table dibots_v2.wvb_news_item restart identity;

select count(*) from dibots_v2.wvb_news_item;

select * from dibots_v2.wvb_news_item order by item_perm_id desc;

--truncate table wvb_news_item restart identity;

select count(*) from wvb_news_item;

--drop table if exists dibots_v2.wvb_news_item_company;
create table dibots_v2.wvb_news_item_company (
id serial primary key,
item_perm_id numeric,
item_language varchar(5),
company_perm_id numeric,
company_id uuid,
external_id numeric,
created_dtime timestamp with time zone not null,
created_by varchar(100) not null,
modified_time timestamp with time zone,
modified_by varchar(100))

select count(*) from dibots_v2.wvb_news_item_company;

--truncate table dibots_v2.wvb_news_item_company restart identity;

insert into dibots_v2.wvb_news_item_company (item_perm_id, item_language, company_perm_id, created_dtime, created_by)
select item_perm_id, item_language, cast(s.token as numeric) as comp_perm_id, now(), 'kangwei' from public.wvb_news_item item, unnest(string_to_array(item.company_perm_id_list, ',')) s(token)

update dibots_v2.wvb_news_item_company tbl
set
company_id = b.dbt_entity_id,
external_id = b.external_id
from dibots_v2.company_profile b
where tbl.company_perm_id = b.wvb_company_id and b.wvb_entity_type = 'COMP'

select * from dibots_v2.wvb_news_item_company where company_id is not null;

select * from dibots_v2.wvb_news_item_company order by id;

select * from dibots_v2.wvb_news_item_company tbl,  dibots_v2.company_profile b
where tbl.company_perm_id = b.wvb_company_id and b.wvb_entity_type = 'COMP'

select count(*) from dibots_v2.wvb_news_item_company where company_id is not null;

select count(*) from dibots_v2.wvb_news_item_company tbl join dibots_v2.company_profile cp on cp.wvb_company_id = tbl.company_perm_id

select wvb_company_id, count(*) from dibots_v2.company_profile group by wvb_company_id having count(*) > 1;

select * from dibots_v2.wvb_news_item_company

select * 
from dibots_v2.wvb_news_item_company news
join dibots_v2.company_profile cp
on news.company_perm_id = cp.wvb_company_id
where cp.wvb_entity_type = 'COMP';

--drop table if exists dibots_v2.wvb_news_attachment;
create table dibots_v2.wvb_news_attachment (
id bigserial primary key,
attachment_perm_id numeric,
item_perm_id numeric,
attachment_url text,
attachment_path text,
attachment_server text,
created_dtime timestamp with time zone not null,
created_by varchar(100) not null,
modified_dtime timestamp with time zone,
modified_by varchar(100)
);

insert into dibots_v2.wvb_news_attachment (attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, created_dtime, created_by)
select attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, now(), 'kangwei' from wvb_news_attachment

select count(*) from dibots_v2.wvb_news_attachment;

select * from dibots_v2.wvb_news_attachment order by attachment_perm_id desc;

select * from dibots_v2.wvb_news_item where item_perm_id = 7696183

select * from dibots_v2.wvb_news_item_body where item_perm_id = 7696183

select * from dibots_v2.wvb_news_attachment where item_perm_id = 7696183

select * from dibots_v2.wvb_news_item_company where item_perm_id = 7696183

-- joining all the wvb_news table together
select * from
(select news.item_perm_id, news.wvb_number, news.item_heading, news.distributor_perm_id, news.format_perm_id, news.item_language, news.type_perm_id, news.topic_perm_id,
news.company_name, news.ticker, news.mic, news.item_url, news.attachment_perm_id, news.attachment_url, news.attachment_path, news.attachment_server, body.item_content, body.item_language 
from 
(select item.item_perm_id, item.wvb_number, item.item_heading, item.distributor_perm_id, item.format_perm_id, item.item_language, item.type_perm_id, item.topic_perm_id,
item.company_name, item.ticker, item.mic, item.item_url, atta.attachment_perm_id, atta.attachment_url, atta.attachment_path, atta.attachment_server 
from dibots_v2.wvb_news_item item 
join dibots_v2.wvb_news_attachment atta
on item.item_perm_id = atta.item_perm_id) news
join dibots_v2.wvb_news_item_body body
on news.item_perm_id = body.item_perm_id) newsbody
join dibots_v2.wvb_news_item_company newscomp
on newsbody.item_perm_id = newscomp.item_perm_id

where item_content is not null;


select
    t.relname as table_name,
    i.relname as index_name,
    a.attname as column_name
from
    pg_class t,
    pg_class i,
    pg_index ix,
    pg_attribute a
where
    t.oid = ix.indrelid
    and i.oid = ix.indexrelid
    and a.attrelid = t.oid
    and a.attnum = ANY(ix.indkey)
    and t.relkind = 'r'
    and t.relname like 'wvb_news%'
order by
    t.relname,
    i.relname;

set schema 'dibots_v2';

create index wvb_news_item_company_company_id_idx on wvb_news_item_company(company_id);
create index wvb_news_item_company_external_id_idx on wvb_news_item_company(external_id);

create index wvb_news_attachment_item_perm_id_idx on dibots_v2.wvb_news_attachment(item_perm_id)