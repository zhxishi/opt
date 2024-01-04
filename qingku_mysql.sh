#!/bin/bash
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
date=`date +%F`
start_month=2023-12-01
dbname="game_2"
table="tbl_gm_dynamic"
field="time"
sql_path=/data/${dbname}
dir=/backup-enjoymi/mysql-backup/Operation_platform
file_path=$dir/$dbname/$table
logfile=$script_path/logs.txt
mysqldump_conn="mysqldump -uroot -pEnjoymi2020HYN -h10.23.114.107 --single-transaction --quick"
mysql_conn="mysql -uroot -pEnjoymi2020HYN -h10.23.114.107"

function check()
{

if [[ $? == 0 ]]; then
      echo " copy table and insert data Successed!" >>$logfile
      echo "END DATE: $(date +"%y-%m-%d %H:%M:%S")" >> $logfile
else
    echo "DataBase Backup Failed！" >>$logfile
	exit 1 
fi
}

echo -e  "\e[31m #############创建${dbname}库${table}表，同步${start_month}后的数据#############\e[0m"
function rename_table()
{
 $mysql_conn $dbname -e "create table ${table}_new like ${table};insert into ${table}_new  select  * from ${table} where ${field} >='$(date -d "${start_month}" +%s)';"
check
 $mysql_conn $dbname -e "rename table ${table} to ${table}_old,${table}_new to ${table};"
}

rename_table

######取指定时间前每个月的第一个时间戳和左后一个时间戳
function get_time(){
#####查询获取开始${start_month}时间以后2个月的时间#######"
##从设置时间向前推1个月的数据
#for ((i=-1; i>-2; i--))
##从设置时间向前推i-1个月的数据
for ((i=-1; i>-4; i--))
do
   s_time=$(date -d "${start_month} +${i} month 00:00:00" +%s)
 # echo "开始: $s_time"

   last_day=$(date -d "${start_month}  +${i} month + 1 month - 1 day" +%Y-%m-%d)
   e_time=$(date -d "$last_day 23:59:59" +%s)
#   echo "结束: $e_time"

   month=$(date -d "${start_month} +${i} month" +%Y%m)
#   echo "月份：$month"
echo -e  "\e[31m ===================开始导出${dbname}库${table}表${month}月数据！！！================================================\e[0m"
   echo "月份：$month"
# sleep 5
 $mysqldump_conn ${dbname} ${table}_old -t --where=''${field}' between '$s_time' and '$e_time'' > ${sql_path}/${table}_$month.sql
 if [ $? -eq 0 ]
 then
      gzip ${sql_path}/${table}_$month.sql
      echo "mysqldump susscess !!"
 else
      echo -e "\e[31m mysqldump failed !!,please check ${sql_path}/${table}_$month.sql file !!\e[0m"
      exit 1
 fi
 
 
echo -e  "\e[31m ===================开始归档${month}月数据！！！======================================\e[0m"
 mv -n ${sql_path}/${table}_$month.sql.gz  ${dir}/${dbname}/${table}/
 if [ $? -eq 0 ] 
 then
   echo "mover susscess !!"
   echo "归档位置在："${dir}/${dbname}/${table}/
 else 
   echo "move faile !!"
 fi
done
}
get_time
check


