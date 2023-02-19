-- CREATE temporary tables for each session
create temp table tmp_wvb_news_item (
item_perm_id bigint NOT NULL,
wvb_number varchar(12),
item_heading varchar(1500) NOT NULL,
distributor_perm_id bigint NOT NULL,
format_perm_id bigint NOT NULL,
item_language varchar(5) NOT NULL,
type_perm_id bigint,
topic_perm_id bigint,
item_publish_time timestamp,
item_gmt_time timestamp,
item_received_time timestamp,
company_name varchar(150),
ticker varchar(20),
mic varchar(4),
isin varchar(12),
item_url text,
item_signature varchar(100),
item_status int,
item_attached int,
item_news_id varchar(100),
dtime_approved timestamp,
dtime_created timestamp,
dtime_last_changed timestamp,
who_created varchar(8),
who_approved varchar(8),
who_last_changed varchar(8),
company_perm_id_list text
);

create temp table tmp_wvb_news_attachment (
attachment_perm_id bigint,
attachment_url text,
attachment_path text,
attachment_server text,
item_perm_id bigint
);

create temp table tmp_wvb_news_item_body (
item_perm_id bigint PRIMARY KEY NOT NULL,
item_content text,
item_language varchar(3)
);


-- WVB_NEWS_ITEM

-- insert into public from foreign
insert into tmp_wvb_news_item (item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time,company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, item_news_id, dtime_approved, dtime_created, dtime_last_changed, who_created, who_approved, who_last_changed, company_perm_id_list)
select item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, item_news_id, dtime_approved, dtime_created, dtime_last_changed, who_created, who_approved, who_last_changed, company_perm_id_list
from oracle.wvb_news_item where item_perm_id > (select max(item_perm_id) from dibots_v2.wvb_news_item);

-- insert into dibots_v2 from public
insert into dibots_v2.wvb_news_item (item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, 
company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, created_dtime, created_by)
select item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, company_name, ticker, mic, isin, item_url,
item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, now(), 'kangwei' from tmp_wvb_news_item ON CONFLICT DO NOTHING;

-- WVB_NEWS_COMPANY
insert into dibots_v2.wvb_news_item_company (item_perm_id, item_language, company_perm_id, created_dtime, created_by)
select item_perm_id, item_language, cast(s.token as numeric) as comp_perm_id, now(), 'kangwei' from tmp_wvb_news_item item, unnest(string_to_array(item.company_perm_id_list, ',')) s(token) ON CONFLICT DO NOTHING;

update dibots_v2.wvb_news_item_company tbl
set
company_id = b.dbt_entity_id,
external_id = b.external_id
from dibots_v2.company_profile b
where tbl.company_perm_id = b.wvb_company_id and b.wvb_entity_type = 'COMP' and tbl.item_perm_id > (select min(item_perm_id) from tmp_wvb_news_item);

-- WVB_NEWS_ATTACHMENT

-- insert into tmp from foreign
insert into tmp_wvb_news_attachment (attachment_perm_id, attachment_url, attachment_path, attachment_server, item_perm_id)
select attachment_perm_id, attachment_url, attachment_path, attachment_server, item_perm_id from oracle.wvb_news_attachment where attachment_perm_id > (select max(attachment_perm_id) from dibots_v2.wvb_news_attachment);

-- insert into dibots_v2 from tmp
insert into dibots_v2.wvb_news_attachment (attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, created_dtime, created_by)
select attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, now(), 'kangwei' from tmp_wvb_news_attachment ON CONFLICT DO NOTHING;

-- WVB_NEWS_ITEM_BODY

-- inserting into tmp from foreign
insert into tmp_wvb_news_item_body (item_perm_id, item_content, item_language)
select wvb_item_perm_id, item_content, item_language from oracle.wvb_news_item_body where (wvb_item_perm_id > (select max(item_perm_id) from dibots_v2.wvb_news_item_body) 
and wvb_item_perm_id <= (select max(item_perm_id) + 1000 from dibots_v2.wvb_news_item_body));

-- insert from tmp to dibots_v2
insert into dibots_v2.wvb_news_item_body (item_perm_id, item_content, item_language, created_dtime, created_by) 
select item_perm_id, item_content, item_language, now(), 'kangwei' from tmp_wvb_news_item_body
ON CONFLICT DO NOTHING;

-- extracting the ann_id
update dibots_v2.wvb_news_item
set
ann_id = split_part(item_url, '=', 2)::bigint
where mic = 'XKLS' and item_url like 'https://www.bursamalaysia%' and ann_id is null;