#!/bin/bash
#!/bin/bash
db_conn=`mysql -uroot -pEnjoymiHdtech123 -h10.35.45.249 -N -e  "select table_name from information_schema.tables where table_schema='webClient' and table_name like '%tbl_device_log_202105%';"`

echo $db_conn

for i in $db_conn 
    do
#    mysql -uroot -pEnjoymiHdtech123 -h10.35.45.249  webClient -e "truncate table $i;"
      mysql -uroot -pEnjoymiHdtech123 -h10.35.45.249  webClient -e " drop table $i;"
    done
