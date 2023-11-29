#!/bin/bash
date=`date '+%Y%m%d%H%M%S'`
####备份原表#########
mysqldump -uroot -ppassword jopp tbl_device_300002 > /tmp/tbl_device_300002-$date

bfile = `ls /tmp/tbl_device_300002-$date`

if [ f $bfile ]
then
    #mysql -uroot -ppassword jopp -e "delete from tbl_device_30002 where hdid in (select hdid from (select count(uid) sum,hdid from tbl_device_30002 where hdid <> '0000000000000000' group by hdid having count(uid) > 3 ) d);"
else  
    echo "backup faild,exit"
	exit 1
fi
echo backup_$date

