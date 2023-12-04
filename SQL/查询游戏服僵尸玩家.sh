#!/bin/bash
#----------------
#查询所有区服玩家
#----------------
script_name=$(basename $0)
script_abs_name=$(readlink -f $0)
script_path=$(dirname $script_abs_name)
DATE=$(date +%F_%H-%M-%S)
USER=root
PASS=EnjoymiHdtech123
PL=LY2
HOST=192.168.1.81
while read dbname 
do
 # mysql -h$HOST -u$USER -p$PASS  ${dbname} -N -e "select '${dbname}',count(*) from tbl_player;" >> ${PL}-$DATE.txt
 mysql -h$HOST -u$USER -p$PASS --default-character-set=utf8  ${dbname}  -e "select '${dbname}',id,nickname,account,level,last_login_time,last_logout_time from tbl_player where last_logout_time <='1609430400';" >> ${PL}-${dbname}-$DATE.txt
done  < ly2.txt
