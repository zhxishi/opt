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
dbname=serverlist
check_var "$@"
if [ $project == g1  ];then

   case ${plat} in
	android)
#		mysql_conn="-uroot -pEnjoymiHdtech123 -h10.23.66.74"
		mysql_conn="mysql -uroot -ppassword -h127.0.0.1"
	;;
	appstore)
		mysql_conn="-uroot -pEnjoymiHdtech123 -h10.23.85.53"
	;;
   esac

elif [ $project == g2  ];then
     case ${plat} in
        android)
                mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.11"
        ;;
        appstore)
                mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.61"
        ;;
   esac
 fi    
 
echo "以下是针对$1的$2平台数据库，请检查是否为正确的数据库连接！！"
echo  ${mysql_conn} 
sleep 10
}
##调用函数，显式传参
get_mysql_conn "$@"

##查询合区后的可以清理的区服
get_delete(){
  ${mysql_conn} $dbname  -e "SELECT
	CONCAT( 'sgzj2_android2_', s.zone ) 已合区服,
	s.ip 公网IP,
	s.NAME 
FROM
	tbl_zoneinfo_android_sgzj2 s 
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
            b.PORT PORT,
            k.ip ip
        FROM
            tbl_zoneinfo_android_sgzj2 k
            LEFT JOIN tbl_zoneinfo_android_sgzj2 b ON k.PORT = b.PORT
            AND k.ip = b.ip
    ) n ON m.PORT = n.PORT
    AND m.ip = n.ip) t
)"

}

get_delete
