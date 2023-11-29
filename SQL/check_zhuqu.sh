#!/bin/bash
##查询国2合服后被合区服的主区服
##查询区服被合后的主服
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`
READ_COLOR='\E[1;31m'
RES='\E[0m'

plat=$1
zone=$2
if [[ $# -ne 2 ]]
then
	echo " please input dbname and zone"
        exit 1
fi
dbname="enjoymi_serverlist"
if [[ ${plat} == "android"  ]]
then 
   tablename="tbl_zoneinfo_android_sgzj2"
   elif [[ ${plat} == "ios" ]]
   then 
       tablename="tbl_zoneinfo_ios_sgzj2"
   elif [[ ${plat} == "ly" ]]
   then
       tablename="tbl_zoneinfo_android_ly_sgzj2"
fi

    
db_conn="-uroot -ppassword"

mysql ${db_conn} ${dbname} -e "SELECT
    min(zone) "主服",ip
FROM
    (
        SELECT
            t.zone,
            t.ip,
            t.PORT
        FROM
            ${tablename} t
            JOIN (
                SELECT
                    PORT,
                    webport,
                    ip
                FROM
                    ${tablename}
                WHERE
                    zone = ${zone}
            ) s ON t.PORT = s.PORT
            AND t.webport = s.webport
            AND s.ip = t.ip
    ) d;"
