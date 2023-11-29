#!/bin/bash
DATE=$(date +%F_%H-%M-%S)
RED='\e[1;31m'
END='\e[0m'
USER=用户名 
PASS=密码
SDBNAME=源库名
DDBNAME=目标库名
TABLENAME=源表名
shost="源库地址"
dhost="目的库地址"
sVersion=`mysql -uroot -pEnjoymiHdtech123 -h${shost} -e "status" |grep "Server version:"|awk -n '{print $3}'|awk -F '.' '{print$1"."$2}'`
dVersion=`mysql -uroot -pEnjoymiHdtech123 -h${dhost} -e "status" |grep "Server version:"|awk -n '{print $3}'|awk -F '.' '{print$1"."$2}'`
if [ $sVersion = $dVersion ];then
   mysqldump --host=$shost  -u$USER -p$PASS  --single-transaction --quick --databases $DBNAME --tables $TABLENAME |mysql --host=$dhost -uroot -p$DPASS $DDBNAME
else
   echo -e "${RED}版本不一致,不能同步！!${END}"
fi
