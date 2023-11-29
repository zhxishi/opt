#!/bin/bash

for i in  log_pay log_register log_install log_login;do mysql -uroot -pEnjoymiHdtech123 -h10.23.55.150 reyun_data -N -e "select '${i}', max(id) from ${i};";done > scn.txt
while  read  tablename  scn
do
mysqldump --host=10.23.10.170 -uroot -pEnjoymiHdtech123  -t --databases reyun_data --tables ${tablename} --where="id>${scn}" |mysql --host=10.23.55.150 -uroot -pEnjoymiHdtech123 reyun_data;
done < /tmp/scn.txt
