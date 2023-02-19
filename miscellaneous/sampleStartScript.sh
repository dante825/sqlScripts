if [[ -f proc.pid ]]; then
        ps -aux | egrep `ls *jar | tr '\n' '|' |sed s/.$// | sed s/\|/\\\\\|/` | grep java | grep `cat proc.pid` && echo "Process is still running, please terminate it first" && exit 1
fi

nohup java -jar `pwd`/elasticsearch-query-client-2.0.0.jar > /dev/null 2>&1&
echo "$!" > proc.pid
sleep 1
ps -aux | egrep `ls *jar | tr '\n' '|' |sed s/.$// | sed s/\|/\\\\\|/` | grep java | grep $! && echo "Started" || echo "Failed to start" && exit 1
