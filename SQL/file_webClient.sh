#!/bin/bash
#webClient埋点库清理
#归档ucloud1的云数据库new_device_NEW的tbl_device_log_日期表
#归档地址为对象存储backup-enjoymi下，mysql-backup/new_device_NEW/webClient

script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`

DATE=`date +%Y%m%d_%H%M%S`
#wait_delete_date=`date -d "-1 months" +%Y%m`
wait_delete_date=`date  -d  "-6 day" +%Y%m%d`
#测试用
#wait_delete_date=202302
mysql_conn="mysql -uroot -pEnjoymiHdtech123 -h10.23.55.150 webClient"
mysqldump_conn="mysqldump -uroot -pEnjoymiHdtech123 -h10.23.55.150 webClient"

table_list=`${mysql_conn} -e "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'webClient' and TABLE_NAME like 'tbl_device_log_${wait_delete_date}';"| grep -v TABLE_NAME`

disk_space=`df -h /home | tail -n 1 | awk '{print $5}' | sed 's/%//g'`

cd ${script_path}


if [[ ${disk_space} -ge 90 ]]
then
	echo "disk space in not enough,exit"
	exit 1
fi


if [[ -d sql_files ]]
then
	rm -f sql_files/*
else 
	mkdir sql_files
fi


if [[ ! -d logs ]]
then
	mkdir logs
fi


for i in `echo ${table_list}`
do
	echo -e "start dump $i"
	${mysqldump_conn} $i > sql_files/$i.sql
	echo -e "dump $i success"
	tar zcf ${i}.sql.tar.gz sql_files/$i.sql
	/home/shell/ucloud_obs/us3cli-linux64 cp ${i}.sql.tar.gz us3://backup-enjoymi/mysql-backup/new_device_NEW/webClient/ >> logs/${DATE}.log
	d=`date +%Y-%m-%d_%H:%M:%S`
	echo -e "success in ${d},${i}.sql.tar.gz" >> logs/${DATE}.log
	if [[ -f ${i}.sql.tar.gz ]]
	then
		find -name "*.tar.gz" -exec rm -f {} \;
		find sql_files -name '*.sql'  -exec rm -f {} \;
	else
	        echo "tbl_device_log_${wait_delete_date}.sql.tar.gz is not exist,exit"
        	exit 1	
	fi
done

drop_table(){
for i in `echo ${table_list}`
do
       ${mysql_conn} -e "truncate table ${i}"
       ${mysql_conn} -e "drop table ${i}"
        echo -e "drop $i"
done
}
drop_table
