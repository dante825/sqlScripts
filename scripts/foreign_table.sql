CREATE FOREIGN TABLE oracle.wvb_news_item_body (
	WVB_ITEM_PERM_ID NUMERIC(29,6) OPTIONS (key 'true') not null,
	ITEM_CONTENT TEXT,
	ITEM_LANGUAGE VARCHAR(3)
) server oradb_news OPTIONS (schema 'WORLDVEST_DEV', table 'WVB_NEWS_ITEM_BODY', readonly 'true', prefetch '200')


--DROP FOREIGN TABLE oracle.wvb_news_item_body

select * from oracle.wvb_news_item_body


drop foreign table oracle.wvb_news_item_body_dbox;

CREATE FOREIGN TABLE oracle.wvb_news_item_body_dbox (
	ITEM_PERM_ID bigint options (key 'true') not null,
	ITEM_CONTENT TEXT,
	ITEM_LANGUAGE VARCHAR(3)
) server oradb OPTIONS (schema 'WVBCLIENT', table 'WVB_NEWS_ITEM_BODY', readonly 'true', prefetch '2000');

SELECT count(*) FROM oracle.wvb_news_item_body_dbox;

select item_perm_id from oracle.wvb_news_item_body_dbox offset 339173 fetch next 10 row only;

select item_content from oracle.wvb_news_item_body_dbox where item_perm_id = 709999

select count(*) from wvb_news_item_body;


-- foreign table for wvb_news_item table
create foreign table oracle.wvb_news_item (
item_perm_id bigint options(key 'true') not null,
wvb_number varchar,
item_heading varchar,
distributor_perm_id numeric,
format_perm_id numeric,
item_language varchar options(key 'true') not null,
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
who_created varchar(100),
who_approved varchar(100),
who_last_changed varchar(100),
company_perm_id_list varchar(3000)
) server oradb_news OPTIONS (schema 'WORLDVEST_DEV', table 'WVB_NEWS_ITEM', readonly 'true', prefetch '2000');

--drop foreign table oracle.wvb_news_item;

select * from oracle.wvb_news_item where company_perm_id_list is not null limit 100;

-- foreign table for wvb_news_attachment
create foreign table oracle.wvb_news_attachment (
attachment_perm_id bigint options(key 'true') not null,
attachment_url text,
attachment_path text,
attachment_server text,
item_perm_id bigint
) server oradb_news OPTIONS (schema 'WORLDVEST_DEV', table 'WVB_NEWS_ATTACHMENT', readonly 'true', prefetch '2000');

--drop foreign table oracle.wvb_news_attachment;

select * from oracle.wvb_news_attachment limit 100;