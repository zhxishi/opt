#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
source /etc/bashrc
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`
##判断执行用户
username=`whoami`
if [ "${username}" != "root" ]; then
    echo "must run by root,exit"
    exit
fi

##判断参数
check_var(){
if [ $# -ne 2 ]; then
    echo "need project platname,exit"
    exit
fi
}

##获取数据库连接
get_mysql_conn() {
project=$1
plat=$2
#mysql_conn="mysql -uroot -pcUz0mt68N -h10.23.210.68"
#dbname=enjoymi_serverlist
mysql_conn="mysql -uroot -ppassword -h127.0.0.1"
dbname=serverlist
check_var "$@"
if [ $project == g1  ];then

   case ${plat} in
	android)
		table_name="tbl_zoneinfo_common_android"
                game_db_name="sgzj_android_"
	;;
	ios)
		table_name="tbl_zoneinfo_appstore_ios"
                game_db_name="sgzj_appstore_"
	;;
	ly)
		table_name="tbl_zoneinfo_android_ly"
                game_db_name="sgzj_android_ly_"
	;;
	papa)
		table_name="tbl_zoneinfo_android_papa"
                game_db_name="gzj_papa_"
	;;
   esac

elif [ $project == g2  ];then
     case ${plat} in
        android)
              table_name="tbl_zoneinfo_android_sgzj2" 
              game_db_name="sgzj2_android2_"
        ;;
        ios)
              table_name="tbl_zoneinfo_ios_sgzj2"
              game_db_name="sgzj2_ios2_"
        ;;
        ly)
              table_name="tbl_zoneinfo_android_ly_sgzj2"
              game_db_name="android_ly_sgzj2"
        ;;
   esac
 fi    
 
echo "以下是针对$1的$2平台数据库，请检查是否为正确的数据库连接！！"
echo  ${mysql_conn} 
sleep 3
}
##调用函数，显式传参
get_mysql_conn "$@"

##查询合区后的可以清理的区服
get_delete(){
  ${mysql_conn} $dbname  -e "SELECT
	CONCAT( '$game_db_name', s.zone ) 已合区服,
	s.ip 公网IP,
        s.port,
	s.NAME 
FROM
	${table_name} s 
WHERE
	s.zone NOT IN
(
select distinct(主区)  from (
  
SELECT
    DISTINCT (m.zone) 主区,
    n.czone 从区,
    n.PORT 端口,
    n.ip 服务器IP
FROM
    (
        SELECT
            min(h.zone) zone,
            h.PORT PORT,
            h.ip ip
        FROM
            (
                SELECT
                    t.zone,
                    t.ip,
                    t.PORT,
                    t.webport
                FROM
                    ${table_name} t
                    RIGHT JOIN (
                        SELECT
                            PORT,
                            ip
                        FROM
                            ${table_name}
                        GROUP BY
                            PORT,
                            ip
                    ) s ON t.PORT = s.PORT
                    AND t.ip = s.ip
            ) h
        GROUP BY
            h.PORT,
            h.ip
        ORDER BY
            1
    ) m
    LEFT JOIN (
        SELECT
            k.zone czone,
            b.PORT PORT,
            k.ip ip
        FROM
            ${table_name} k
            LEFT JOIN ${table_name} b ON k.PORT = b.PORT
            AND k.ip = b.ip
    ) n ON m.PORT = n.PORT
    AND m.ip = n.ip) t
)"

}

sleep 5

##查询合区后主区信息
get_master(){
 ${mysql_conn} $dbname  -e "SELECT
    DISTINCT(CONCAT('$game_db_name', m.zone)) 主区服,	
    m.PORT 端口,
    m.ip 服务器IP,
		m.name
FROM
   
     (    SELECT
            min(h.zone) zone,
            h.PORT PORT,
            h.ip ip,
						h.name
        FROM
            (
                SELECT
                    t.zone,
                    t.ip,
                    t.PORT,
                    t.webport,
										t.name
                FROM
                    tbl_zoneinfo_android_sgzj2 t
                    RIGHT JOIN (
                        SELECT
                            PORT,
                            ip
                        FROM
                            tbl_zoneinfo_android_sgzj2
                        GROUP BY
                            PORT,
                            ip
                    ) s ON t.PORT = s.PORT
                    AND t.ip = s.ip
            ) h
        GROUP BY
            h.PORT,
            h.ip
        ORDER BY
            1
    ) m
    LEFT JOIN (
        SELECT
            k.zone czone,
            k.PORT PORT,
            k.ip ip,
						k.name
        FROM
            tbl_zoneinfo_android_sgzj2 k
            LEFT JOIN tbl_zoneinfo_android_sgzj2 b ON k.PORT = b.PORT
            AND k.ip = b.ip
    ) n ON m.PORT = n.PORT
    AND m.ip = n.ip"
}
echo "--------合区后的可以清理的区服----------"
sleep 5
get_delete


echo "------------------查询主区-----------------------"
sleep 5
get_master
