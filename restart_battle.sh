#!/bin/bash
cur_dateTime=`date +"%Y-%m-%d %H:%M:%S"`
echo starttime $cur_dateTime
cd /home/enjoymi/sgzj2_android2_bat_1/prod_sgzj_server/bin
echo "++++++++++开始重启+++++++++++++++++++++++++++++++++++"
sh status.sh
sleep 10
echo endtime $cur_dateTime
echo "==========查看状态=================================="
sh status.sh
echo endtime $cur_dateTime
