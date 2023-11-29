#!/bin/bash
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
#source /etc/bashrc
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`
username=`whoami`
if [ "${username}" != "root" ]; then
    echo "must run by root,exit"
    exit
fi

#if [ $# -ne 1 ]; then
#    echo "need plat_form,exit"
#    exit
#fi

#plat_form=$1

#databasename=$2

while read plat_id dbname user_id;do 

echo $plat_id $dbname;

if [[ $plat_id == "34" ]];then
   mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.11 sgzj2_android_${dbname}  tbl_player "
   elif [[ $plat_id == "33" ]];then
     mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.61 sgzj2_ios_${dbname} tbl_player"
   elif  [[ $plat_id == "35" ]];then
    mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.81 sgzj2_ly_${dbname} tbl_player"
fi

mysqldump $mysql_conn -t  --where "id='${user_id}'" > /tmp/${user_id}_`date +%s`.sql


#let plat_id++

done < list.txt

