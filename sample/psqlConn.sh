nohup psql "dbname=dibots host=localhost user=dbsuser password=db5Us31 port=5432" -f /mnt/sdb/dibots/kw-app/corpNewsUpdater/corpNewsInsertion.sql > /mnt/sdb/dibots/kw-app/corpNewsUpdater/output.txt 2>&1&
echo "$!" > proc.pid
