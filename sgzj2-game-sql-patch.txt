#!/bin/bash
#
# 脚本功能：为游戏服打指定补丁
# 并行打补丁
#

if [ $# -ne 1 ]; then
	echo "Usage:sh $0 <patchfilename>"
	echo "Usage:sh $0 example.sql"
	exit
fi

sqlpatchfile=$1
count=0

for i in `ls /home/enjoymi/`;do
  let count++  
{
    if [ -d /home/enjoymi/$i ]; then
    #echo $i
	if [ -f /home/enjoymi/${i}/prod_sgzj_server/bin/install_gamedb_patch.sh ]; then
	    cd /home/enjoymi/${i}/prod_sgzj_server/bin/
		echo "use install_gamedb_patch"
        sh ./install_gamedb_patch.sh ${sqlpatchfile}
	    if [ $? -ne 0 ]; then
               echo "${i} faild"
            fi
        fi
    fi

    if [ ! -f /home/enjoymi/${i}/prod_sgzj_server/bin/install_gamedb_patch.sh ]; then
            cd /home/enjoymi/${i}/prod_sgzj_server/bin/
      		echo "use install_dbpatch"
            sh ./install_dbpatch.sh ${sqlpatchfile}
            if [ $? -ne 0 ]; then
		echo "${i} faild"
	    fi
    fi

    echo "=========== ${i} OK =========== $count"

}&

done

wait
id=`awk '/^id:/ {print $2}' /etc/salt/minion`

echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++++++++++ ${id} server Finsh +++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"