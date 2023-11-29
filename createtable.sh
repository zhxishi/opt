#!/bin/sh
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%F`
username=`whoami`
dbuser='root'
passwd='password'

mycmd="mysql -u$dbuser -p$passwd"
# mycmd="mysql -u$dbuser -p$passwd -S /home/adam/env/mysql-5.7/mysql.sock"

for db_i in {1..2};do
    # 删库
    $mycmd -e "drop database if exists sgzj2_android2_$db_i;"
    # 建库
    $mycmd -e "CREATE DATABASE sgzj2_android2_$db_i DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
    
    for tbl_i in {01..05};do
        # 建表
        $mycmd -e "use sgzj2_android2_$db_i; DROP TABLE IF EXISTS tbl_device_log_202210_$tbl_i;create table tbl_device_log_202210_$tbl_i (
         l_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
         time int(10) unsigned NOT NULL DEFAULT '0',
         gid tinyint(1) unsigned NOT NULL DEFAULT '0',
         device_id varchar(64) NOT NULL DEFAULT '',
         channel_id varchar(32) NOT NULL DEFAULT '',
         method varchar(30) NOT NULL DEFAULT '',
         ltype int(10) unsigned NOT NULL DEFAULT '0',
         isnewpassport tinyint(1) NOT NULL DEFAULT '0',
         devicenew tinyint(1) NOT NULL DEFAULT '0' COMMENT '??????????',
         isnew tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '?????????',
         idfa varchar(70) NOT NULL DEFAULT '',
         player_id bigint(20) unsigned NOT NULL DEFAULT '0',
         localversion varchar(35) NOT NULL DEFAULT '' COMMENT '???',
         tdid varchar(35) NOT NULL DEFAULT '' COMMENT 'talkingdata id',
         imei varchar(50) NOT NULL DEFAULT '' COMMENT '?????????',
         android_id varchar(50) NOT NULL DEFAULT '' COMMENT 'Android??????',
         oaid varchar(100) NOT NULL DEFAULT '' COMMENT '???????',
         apksign varchar(35) NOT NULL DEFAULT '' COMMENT '??sign',
         afid varchar(35) NOT NULL DEFAULT '' COMMENT 'appsflyer id',
         uid varchar(25) NOT NULL DEFAULT '' COMMENT 'uid',
         udevice_id varchar(64) NOT NULL DEFAULT '' COMMENT '?????????',
         extra varchar(1024) NOT NULL DEFAULT '' COMMENT 'extra??',
         first_active tinyint(1) NOT NULL DEFAULT '0' COMMENT '???????0=>??1=>?',
         bury_version varchar(100) NOT NULL DEFAULT '' COMMENT '?????',
         timestamp bigint(20) NOT NULL DEFAULT '0' COMMENT '??',
         send_id bigint(20) NOT NULL DEFAULT '0' COMMENT '????????id',
         from_type tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '????(0,?????;1,??SDK)',
         PRIMARY KEY (l_id),
         KEY time (time),
         KEY device_id (device_id),
         KEY player_id (player_id),
         KEY oaid (oaid)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;"
    done
done
echo "创建完成..."


