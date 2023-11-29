#!/bin/bash
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%F_%H-%M-%S`

mysql_conn="-uroot -ppassword"
#ssh root@106.75.216.198 "mysql -h10.23.210.68 -uroot -pcUz0mt68N enjoymi_serverlist
idfile=online_id.txt
g2uidqu=`cat ${idfile} |cut -b 3-6 |sed -r 's/0*([0-9])/\1/'`

#printf "Input plat (android|ios|ly): "
#read p
for p in ly android ios
do
case $p in
        ly)
                table_name=tbl_zoneinfo_android_ly_sgzj2
                plat=android2_ly
                ;;
        android)
                table_name=tbl_zoneinfo_android_sgzj2
                plat=android2
                ;;
        ios)
                table_name=tbl_zoneinfo_ios_sgzj2
                plat=ios2
                ;;
esac
check_qu(){
mysql ${mysql_conn} enjoymi_serverlist -e "SELECT DISTINCT
         n.czone 从区,',',
	concat('sgzj2_${plat}_',(m.zone)) 主区
--	n.PORT 端口,',',
--	n.ip 服务器ip 
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
			RIGHT JOIN ( SELECT PORT, ip FROM ${table_name}
			GROUP BY PORT, ip ) s ON t.PORT = s.PORT 
			AND t.ip = s.ip 
		) h 
	GROUP BY
		h.PORT,
		h.ip 
	ORDER BY
		1 
	) m,
	(
	SELECT
		k.zone czone,
		b.PORT PORT,
		k.ip ip 
	FROM
		${table_name} k
		LEFT JOIN ${table_name} b ON k.PORT = b.PORT 
		AND k.ip = b.ip 
	) n 
WHERE
	m.PORT = n.PORT 
	AND m.ip = n.ip
        order by 1               ;"

}
check_qu | sed 's/[[:space:]]//g' > sgzj2_${plat}_${timestamp}.txt
done

