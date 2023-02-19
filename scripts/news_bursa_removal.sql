
drop table tmp_bursa_news;
create table tmp_bursa_news (
item_perm_id bigint primary key,
matched_entity text,
org_entity text,
cleansed_org text,
cleansed_matched text
);

select * from tmp_bursa_news where cleansed_matched is not null

select * from tmp_bursa_news where cleansed_org = '""'

update tmp_bursa_news 
set cleansed_org = null
where cleansed_org = '""'

update tmp_bursa_news 
set
cleansed_matched = regexp_replace(cleansed_matched, '''', '', 'g')
where cleansed_matched is not null


select * from dibots_v2.wvb_news_item_body a, tmp_bursa_news b
where a.item_perm_id = b.item_perm_id

update dibots_v2.wvb_news_item_body a
set
matched_entity = b.cleansed_matched,
org_entity = b.cleansed_org,
ner_date = now(),
modified_by = 'kangwei',
modified_dtime = now()
from tmp_bursa_news b
where a.item_perm_id = b.item_perm_id


select * from dibots_v2.wvb_news_item_body where modified_dtime::date = '2020-10-06'

select * from dibots_v2.wvb_news_item_body where item_perm_id = 7639265

select * from dibots_v2.wvb_news_item_body where org_entity is not null

select * from dibots_v2.wvb_news_item_body where matched_entity is null and ner_flag is true

select * from dibots_v2.wvb_news_item_body where org_entity = '""'


[{"entityName": "CONCRETE ENGINEERING PRODUCTS BHD", "entityId": 7515}, {"entityName": "SUNWAY BERHAD", "entityId": 79306}]
[{"entityName": "BURSA MALAYSIA SECURITIES BERHAD", "entityId": 23613323}, {"entityName": "CONCRETE ENGINEERING PRODUCTS BHD", "entityId": 7515}, {"entityName": "SUNWAY BERHAD", "entityId": 79306}]


select * from dibots_v2.importer_index

truncate table dibots_v2.importer_index restart identity