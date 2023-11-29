#!/bin/bash
script_name=$(basename $0)
script_abs_name=$(readlink -f $0)
script_path=$(dirname $script_abs_name)
DATE=$(date +%F_%H-%M-%S)
USER=root
PASS=password
#PASS=EnjoymiHdtech123
#DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |egrep -v "devops_center|information_schema|mysql|performance_schema|test")
plat=(android ios ly)
for pl in ${plat[*]};do
    case ${pl} in
                android)
                  HOST=localhost
                ;;
                ios)
                  HOST=127.0.0.1
                ;;
                ly)
                   HOST=192.168.26.140
                ;;
        esac

DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |egrep -v "devops_center|information_schema|mysql|performance_schema|test")
    for db in ${DB_LIST};do
          mysql -h$HOST -u$USER -p$PASS  ${db} -N -e "select '${db}',count(*) from tbl_player;" >> g1_${pl}-$DATE.txt
     done
done
