#!/bin/bash
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`

while read dbname;do

echo $dbname
mysql_conn="-uroot -pEnjoymiHdtech123 -h10.23.85.53 ${dbname} tbl_tmall_transaction"
mysqldump $mysql_conn -t --where "pay_time<1609430400"  >> /tmp/sgzj1_tbl_tmall_transaction_`date +%F`.sql

done < list.txt
