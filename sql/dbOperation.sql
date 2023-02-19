SELECT
  pid,
  now() - pg_stat_activity.query_start AS duration,
  query,
  client_addr,
  state, application_name
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '2 minutes';


--Soft cancel
select pg_cancel_backend(22588)

--Hard cancel
SELECT pg_terminate_backend(18406);

-- To check if any process locking the table
SELECT pid, relname
  FROM pg_locks l
  JOIN pg_class t ON l.relation = t.oid AND t.relkind = 'r'
 WHERE t.relname = '<table_name>';

-- To check if any process is blocked
select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0

--get all index
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
   -- and t.relname like 'mytable'
order by
    t.relname,
    i.relname;

set schema 'dibots_v2'

select * from equity_security_owner limit 10

select * from equity_security limit 10

CREATE INDEX equity_security_owner_owner_id_idx ON equity_security_owner(owner_id);
CREATE INDEX equity_security_owner_company_id_idx ON equity_security_owner(company_id);

select * from wvb_dir_dealing;

create index wvb_dir_dealing_company_id_idx on wvb_dir_dealing(company_id);

create index wvb_dir_dealing_dealer_id_idx on wvb_dir_dealing(dealer_id);