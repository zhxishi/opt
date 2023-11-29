#!/bin/bash
#本脚本为合服后区服出现重复nickname时数据库去重脚本！！
#确认提示
function confirm()
{
read -r -p "Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
		echo "Yes"
		;;

    [nN][oO]|[nN])
		echo "没有重复，不需要修改。。。。"
    exit 1
    ;;

    *)
		echo "Invalid input..."
		exit 1
		;;
esac
}
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
source /etc/bashrc
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`
username=`whoami`
if [ "${username}" != "root" ]; then
    echo "must run by root,exit"
    exit
fi

if [ $# -ne 1 ]; then
    echo "need databasename,exit"
    exit
fi
databasename=$1


##安全起见根据需要打开对应平台注释
## Android 
#mysql_conn="-uroot -h192.168.1.11 -pEnjoymiHdtech123"
## Appstore
#mysql_conn="-uroot -pEnjoymiHdtech123 -h192.168.1.61"

# 识别平台，如识别使用上方注释
#plat=` ls /home/enjoymi | head -n 1 | awk -F_ '{print $2}'`
#case ${plat} in
#	android)
#		mysql_conn="-uroot -pEnjoymiHdtech123 -h10.23.66.74"
#	;;
#	appstore)
#		mysql_conn="-uroot -pEnjoymiHdtech123 -h10.23.85.53"
#	;;
#esac
echo -e "${mysql_conn}" 
echo -e "\033[32m+++++++++++++++查询重复nickname++++++++++\033[0m"
mysql   ${mysql_conn}   -e "use ${databasename};select id,nickname from tbl_player where nickname in (select nickname from tbl_player where nickname <> ''  group by nickname  HAVING count(nickname)>=2);"


echo -e "\033[32m是否需要修改？:\033[0m"
confirm



echo -e "\033[32m++++++++++++++开始修改重复nickname...........\033[0m"
mysql   ${mysql_conn}   -e "use ${databasename};UPDATE tbl_player 
SET nickname = concat( id, '_', nickname ) 
WHERE
	id IN (
	SELECT
		id 
	FROM
		(
		SELECT
			t.id 
		FROM
			tbl_player t,(
			SELECT
				nickname 
			FROM
				tbl_player 
			WHERE
				nickname <> '' 
			GROUP BY
				nickname 
			HAVING
				count( nickname )>= 2 
			) t1 
		WHERE
			t1.nickname = t.nickname 
		) t3 
	);" 
