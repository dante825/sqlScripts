-- WVB_NEWS_ITEM
truncate table public.wvb_news_item restart identity;

-- insert into public from foreign
insert into public.wvb_news_item (item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time,company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, item_news_id, dtime_approved, dtime_created, dtime_last_changed, who_created, who_approved, who_last_changed, company_perm_id_list)
select item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, item_news_id, dtime_approved, dtime_created, dtime_last_changed, who_created, who_approved, who_last_changed, company_perm_id_list
from oracle.wvb_news_item where item_perm_id > (select max(item_perm_id) from dibots_v2.wvb_news_item);

-- insert into dibots_v2 from public
insert into dibots_v2.wvb_news_item (item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, 
company_name, ticker, mic, isin, item_url, item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, created_dtime, created_by)
select item_perm_id, wvb_number, item_heading, distributor_perm_id, format_perm_id, item_language, type_perm_id, topic_perm_id, item_publish_time, item_gmt_time, item_received_time, company_name, ticker, mic, isin, item_url,
item_signature, item_status, item_attached, dtime_approved, dtime_created, dtime_last_changed, now(), 'kangwei' from public.wvb_news_item ON CONFLICT DO NOTHING;

-- WVB_NEWS_COMPANY
insert into dibots_v2.wvb_news_item_company (item_perm_id, item_language, company_perm_id, created_dtime, created_by)
select item_perm_id, item_language, cast(s.token as numeric) as comp_perm_id, now(), 'kangwei' from public.wvb_news_item item, unnest(string_to_array(item.company_perm_id_list, ',')) s(token) ON CONFLICT DO NOTHING;

--update dibots_v2.wvb_news_item_company tbl
--set
--company_id = b.dbt_entity_id,
--external_id = b.external_id
--from dibots_v2.company_profile b
--where tbl.company_perm_id = b.wvb_company_id and b.wvb_entity_type = 'COMP';

update dibots_v2.wvb_news_item_company tbl
set
company_id = b.dbt_entity_id,
external_id = b.external_id
from dibots_v2.company_profile b
where tbl.company_perm_id = b.wvb_company_id and b.wvb_entity_type = 'COMP' and tbl.item_perm_id > (select min(item_perm_id) from public.wvb_news_item);

-- WVB_NEWS_ATTACHMENT
truncate table public.wvb_news_attachment restart identity;

-- insert into public from foreign
insert into public.wvb_news_attachment (attachment_perm_id, attachment_url, attachment_path, attachment_server, item_perm_id)
select attachment_perm_id, attachment_url, attachment_path, attachment_server, item_perm_id from oracle.wvb_news_attachment where attachment_perm_id > (select max(attachment_perm_id) from dibots_v2.wvb_news_attachment);

-- insert into dibots_v2 from public
insert into dibots_v2.wvb_news_attachment (attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, created_dtime, created_by)
select attachment_perm_id, item_perm_id, attachment_url, attachment_path, attachment_server, now(), 'kangwei' from public.wvb_news_attachment ON CONFLICT DO NOTHING;

-- WVB_NEWS_ITEM_BODY
truncate table public.wvb_news_item_body restart identity;

-- inserting into public from foreign
insert into public.wvb_news_item_body (item_perm_id, item_content, item_language)
select wvb_item_perm_id, item_content, item_language from oracle.wvb_news_item_body where wvb_item_perm_id > (select max(item_perm_id) from dibots_v2.wvb_news_item_body);

-- insert from public to dibots_v2
insert into dibots_v2.wvb_news_item_body (item_perm_id, item_content, item_language, created_dtime, created_by) 
select item_perm_id, item_content, item_language, now(), 'kangwei' from public.wvb_news_item_body
ON CONFLICT DO NOTHING;
