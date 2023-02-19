select * from dibots_v2.wvb_news_item_body where matched_entity is not null

select b.item_perm_id, b.item_content, b.item_language from dibots_v2.wvb_news_item a, dibots_v2.wvb_news_item_body b
where a.item_perm_id = b.item_perm_id and a.mic = 'XKLS' and b.item_language = 'en' limit 100

select * from dibots_v2.wvb_news_item_body where modified_by = 'kangwei' and modified_dtime::date = '2020-07-06'

select * from dibots_v2.wvb_news_item;


select * from dibots_v2.wvb_news_item_body where modified_by = 'kangwei' order by modified_dtime desc


select * from dibots_v2.wvb_news_item_body where item_perm_id = 7638986

select count(*) from dibots_v2.wvb_news_item a, dibots_v2.wvb_news_item_body b
where a.item_perm_id = b.item_perm_id and a.mic = 'XKLS' and b.created_dtime::date = '2020-07-01' and b.item_language = 'en'

select count(*) from dibots_v2.wvb_news_item a, dibots_v2.wvb_news_item b
where a.item_perm_id = b.item_perm_id and b.mic = 'XKLS' and
a.item_perm_id between 8123429 and 8124357

select * from dibots_v2.wvb_news_item_body where item_perm_id = 8123031

select count(*) from dibots_v2.wvb_news_item_body where created_dtime > '2020-07-02 10:00'

select * from dibots_v2.wvb_news_item_body where item_language is null

SELECT count(*) FROM dibots_v2.wvb_news_item_body WHERE created_dtime::date = '2020-07-01' and item_language = 'en'

select count(*) from dibots_v2.wvb_news_item where mic = 'XKLS'

select * from dibots_v2.wvb_news_item;

alter table dibots_v2.wvb_news_item_body,
add column cleaned_content text,
add column org_entity text,
add column per_entity text,
add column loc_entity text,
add column mis_entity text,
add column matched_entity text,
add column ner_flag bool default false,
add column ner_date timestamp with time zone,
add column ner_model_version numeric(10,2)

alter table dibots_v2.wvb_news_item_body add column matched_entity text;


