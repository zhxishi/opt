#!/bin/bash
# Author: Harry
# Description: Database backup script
dbback(){
# 定义变量
db_user="ma_prd"
db_passwd="<password>"
db_path="/data/bakmysql"
db_file="backuprecord"
db_date=`date +%Y%m%d_%H:%M:%S`
# 判断路径是否存在
[ -d $db_path ] || exit 2
# 使用mysqldump备份数据，并用gzip进行压缩
mysqldump -u$db_user  -p$db_passwd --single-transaction ma  | gzip > $db_path/${db_date}_ma.sql.gz
REVAL=$?
if [ $REVAL -eq 0 ]
    then
        echo "$db_date ma db is backups successful" >>$db_path/$db_file
    else
        echo "$db_date ma db is backups failed" >>$db_path/$db_file
fi
}

#删除超过7天的备份数据
delbak(){
local db_path="/data/bakmysql"
find $db_path -type f -name "*ma*.gz" -mtime +7 -exec rm -rf {} \;
}
dbback
delbak