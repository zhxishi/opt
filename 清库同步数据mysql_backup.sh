#!/timen/bash
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
date=`date +%F`
dbname="game_1"
table="tbl_gm_battleatr"
sql_path=/data/${dbname}
start_month=2023-11-01
dir=/backup-enjoymi/mysql-backup/Operation_platform
file_path=$dir/$dbname/$table
logfile=$sql_path/logs.txt
mysqldump_conn="mysqldump -uroot -pEnjoymi2020HYN -h10.23.114.107 --single-transaction --quick"
mysql_conn="mysql -uroot -pEnjoymi2020HYN -h10.23.114.107"

function check()
{

if [[ $? == 0 ]]; then
      echo " Backup Successed!" >>$logfile
      echo "BACKUP END DATE: $(date +"%y-%m-%d %H:%M:%S")" >> $logfile
else
    echo "DataBase Backup Failed！" >>$logfile
	exit 
fi
}

echo " #############同步数据，修改表名#############"
function rename_table()
{
echo $mysql_conn $dbname -e "create table ${table}_new like ${table};insert into ${table}_new  select  * from ${table} where time >='$(date -d "${start_month}" +%s)';"
#check
echo  $mysql_conn $dbname -e "rename table ${table} to ${table}_old,${table}_new to ${table};"
}

rename_table

######取指定时间前每个月的第一个时间戳和左后一个时间戳
function get_time(){
echo  "#####查询获取开始${start_month}时间以后2个月的时间#######"
for ((i=-1; i>=-2; i--))
do
   s_time=$(date -d "${start_month} +${i} month" +%s)
  echo "开始: $s_time"

   last_day=$(date -d "${start_month}  +${i} month + 1 month - 1 day" +%Y-%m-%d)
   e_time=$(date -d "$last_day" +%s)
   echo "结束: $e_time"
done
}
######取制定时间后每个月的第一个时间戳和左后一个时间戳
#function get_time(){
#echo  "#####查询获取开始${start_month}时间以后2个月的时间#######"
#for ((i=0; i<2; i++))
#do
#   s_time=$(date -d "${start_month} +${i} month" +%s)
##   echo "开始: $s_time"
#
#   last_day=$(date -d "${start_month}  +${i} month + 1 month - 1 day" +%Y-%m-%d)
#   e_time=$(date -d "$last_day" +%s)
##   echo "结束: $e_time"
#done      
#}

get_time

echo ===================导出数据===============================================================


#$mysqldump_conn ${dbname} ${table}_old -t --where='time between '$s_time' and '$e_time'' > ${sql_path}/${table}_$month.sql
echo "$mysqldump_conn ${dbname} ${table}_old -t --where='time between '$s_time' and '$e_time''| gzip > ${sql_path}/${table}_$month.sql.gz"




#########不规则时间可以使用一下代码#####
#while IFS="," read s_time e_time month
#do
#echo ===================导出数据===============================================================
#$mysqldump_conn ${dbname} ${table}_old -t --where='time between '$s_time' and '$e_time'' > ${sql_path}/${table}_$month.sql
#$mysqldump_conn ${dbname} ${table}_old -t --where='time between '$s_time' and '$e_time''| gzip > ${sql_path}/${table}_$month.sql.gz
#check
#echo ===================tar文件=================================================================
#tar -zcPf $dir/$dbname/$table/${table}_$month.tar.gz $sql_path/${table}_$month.sql --remove-files
#check
#done < list.txt
#######################################
