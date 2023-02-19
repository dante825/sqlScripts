DROP TABLE IF EXISTS dibots_v2.importer_index;
CREATE TABLE dibots_v2.importer_index (
id SERIAL PRIMARY KEY,
importer_name varchar(100) UNIQUE,
index_name varchar(100),
alias varchar(100),
type varchar(100),
active_state varchar(100),
--exec_state varchar(100),
completion_state varchar(100),
reindex_flag boolean,
run_count int,
new_records int,
created_on TIMESTAMP WITH TIME ZONE,
last_run_on TIMESTAMP WITH TIME ZONE,
updated_on TIMESTAMP WITH TIME ZONE,
last_run_started_on TIMESTAMP WITH TIME ZONE,
last_run_finished_on TIMESTAMP WITH TIME ZONE,
last_successful_run TIMESTAMP WITH TIME ZONE,
cron_expression varchar(100),
status_desc varchar(250),
new_index_name varchar(100));

truncate table dibots_v2.importer_index RESTART IDENTITY;

SELECT * FROM dibots_v2.importer_index;