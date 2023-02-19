select * from dibots_v2.wvb_news_item order by item_publish_time desc

select count(*) from dibots_v2.wvb_news_item where item_publish_time > '2020-03-14';

select count(*) from dibots_v2.wvb_news_item where mic = 'XNZX';

update dibots_v2.wvb_news_item news
set 
mic = 'XNZE'
where mic = 'XNZX';

update dibots_v2.wvb_news_item news
set
item_publish_time = cast(res.right_publish_time as timestamp),
item_gmt_time = cast(res.right_gmt_time as timestamp),
modified_time = now(),
modified_by = 'kangwei'
from
(select item_perm_id, TO_CHAR(ITEM_PUBLISH_TIME,'yyyy-dd-mm hh:mm:ss') as right_publish_time, to_char(item_gmt_time, 'yyyy-dd-mm hh:mm:ss') as right_gmt_time
from dibots_v2.wvb_news_item where item_publish_time > '2020-03-14') res
where news.item_perm_id = res.item_perm_id;

select * from dibots_v2.wvb_news_item where item_perm_id = 7903503