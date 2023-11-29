#!/bin/bash

source ~/.bashrc
#国2的gm                                                   106.75.214.201
#国1的serlist(经过礼包码服务器跳转连接serverlist数据库)    106.75.216.198
#如下两个参数暂未使用
gm_host='106.75.214.201'
serverlist='106.75.216.198'


#数据库账号与密码
host=120.132.21.178
port=3306
username=root
password='135792468.'

dates=$(date +%Y-%m-%d)
dates_tmp=$(date +%Y%m%d)
#dates='2020-06-03'


#mail_whos="1127041566@qq.com 543251454@qq.com 630906954@qq.com lulihua@mylstone.com 1878145574@qq.com 52641256666668@qq.com 81020663@qq.com yanwillis@icloud.com 569602629@qq.com"
mail_whos="all-yw@enjoymi.com all-op@enjoymi.com"
#mail_whos="caizhengyi@enjoymi.com"

dirlists=$(mysql -u${username} -h${host} -p${password} -P$port -e "select dir from game_info.information where region='inland2' and state=0 and start_time='$dates'"|sed -n '2,$p')
#dirlist=sgzj_android2_30
echo $dirlists
#exit 0
if [[ -z $dirlists ]];then
   echo "今天未有开服,不需要执行" 
   exit 1
else
#    for dirlist in $dirlists
#    do
#        echo $dirlist
#        client_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select client_id from game_info.information where dir='$dirlist'"|sed -n '2p')
#        #client_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select client_id from game_info.information where dir='$i'"|sed -n '2p')
#echo $client_id
#        salt "$client_id" game1.state start $dirlist
#    done
#sleep 300
    for dirlist in $dirlists
    do  
        echo $dirlist
        client_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select client_id from game_info.information where dir='$dirlist'"|sed -n '2p')
        table_names=$(mysql -u${username} -h${host} -p${password} -P$port -e "select table_names from game_info.information where dir='$dirlist'"|sed -n '2p')
        #如下是gm参数
        channel_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select channel_id from game_info.information where dir='$dirlist'"|sed -n '2p')
        platform_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select platform_id from game_info.information where dir='$dirlist'"|sed -n '2p')
        server_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select server_id from game_info.information where dir='$dirlist'"|sed -n '2p')
        DESC=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select concat(platform,'-',server_id,'服','-',names) from game_info.information where dir='$dirlist'"|sed -n '2p')
        addr=$(mysql -u${username} -h${host} -p${password} -P$port -e "select concat(ip_out,':',gm_port) from game_info.information where dir='$dirlist'"|sed -n '2p')
        secret_key='/qEOfXDgfGWQ5lZBfCtA/VZmgWwhbvSM/n7IagAFhHw='
        echo "如下gm数据库参数"
        echo "channel_id:"$channel_id "platform_id:"$platform_id "server_id:"$server_id "desc"$DESC "addr:"$addr "secret_key:"$secret_key
        gm_commands_select="mysql -uroot -e \"select * from sgzj2_gm.tbl_server where id='$channel_id'\""
        gm_result=$(pssh -H ubuntu@106.75.214.201 -i "$gm_commands_select"|sed -n '3p')
        if [[ ! -n "${gm_result}" ]];then
            gm_commands="mysql -uroot -e \"insert into sgzj2_gm.tbl_server value ('$channel_id','$platform_id','$server_id','$DESC','$addr','$secret_key')\""
            pssh -H ubuntu@106.75.214.201 -i "$gm_commands"
            echo "插入成功"
        else
            echo "库中数据已存在"
        fi

        #pssh -H ubuntu@106.75.214.201 -i 'mysql -uroot -e "insert into sgzj2_gm.tbl_server value ('$channel_id','$platform_id','$server_id','\'$desc\'','\'$addr\'','\'$secret_key\'')"'
        #gm_commands="mysql -uroot -e \"insert into sgzj2_gm.tbl_server value ('$channel_id','$platform_id','$server_id','$DESC','$addr','$secret_key')\""
        #pssh -H ubuntu@106.75.214.201 -i "$gm_commands"

        #如下是serverlist参数
        game=2
        pid=0
        zone=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select server_id from game_info.information where dir='$dirlist'"|sed -n '2p')
        name=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select names from game_info.information where dir='$dirlist'"|sed -n '2p')
        ip=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select ip_out from game_info.information where dir='$dirlist'"|sed -n '2p')
        PORT=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select game_port from game_info.information where dir='$dirlist'"|sed -n '2p')
        webport=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select web_port from game_info.information where dir='$dirlist'"|sed -n '2p')
        start_time=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select start_time from game_info.information where dir='$dirlist'"|sed -n '2p')
        start_time="${start_time} 10:00:00"
        type=0
        status=0
        tips=0
        disable_giftcode=0
        end_time=''
        desc=''
        serverstatus=0
        recommend=0
        disable_role=0
        echo "如下serverlist数据库参数"
        echo "game:"$game "pid:"$pid "zone:"$zone "name:"$name "ip:"$ip "port:"$port "webport:"$webport "type:"$type "status:"$status "tips:"$tips "disable_giftcode:"$disable_giftcode "start_time:"$start_time "end_time:"$end_time "desc:"$desc "serverstatus:"$serverstatus "recommend:"$recommend "disable_role:"$disable_role

        #serverlist_commands_select="mysql -h10.23.121.47 -uroot -p'cUz0mt68N' -e \"select * from enjoymi_serverlist.${table_names} where zone='$zone'\""
        serverlist_commands_select="mysql -h10.23.210.68 -uroot -p'cUz0mt68N' -e \"select * from enjoymi_serverlist.${table_names} where zone='$zone'\""
        serverlist_result=$(pssh -H root@106.75.216.198 -i "$serverlist_commands_select"|sed -n '3p')
        #serverlist_commands_select="mysql -h10.23.121.47 -uroot -p'cUz0mt68N' -e \"insert into enjoymi_serverlist.${table_names} value ('$game','$pid','$zone','$name','$ip','$PORT','$webport','$webport','$type','$status','$tips','$disable_giftcode','$start_time','$end_time','$desc','$serverstatus','$recommend','$disable_role')\""
        #pssh -H root@106.75.216.198 -i "$serverlist_commands_select"
        if [[ ! -n "${serverlist_result}" ]];then
            serverlist_commands_select="mysql -h10.23.210.68 -uroot -p'cUz0mt68N' -e \"insert into enjoymi_serverlist.${table_names} value ('$game','$pid','$zone','$name','$ip','$PORT','$webport','$type','$status','$tips','$disable_giftcode','$start_time','$end_time','$desc','$serverstatus','$recommend','$disable_role')\""
            pssh -H root@106.75.216.198 -i "$serverlist_commands_select"
            echo "插入成功" $table_names
        else
            echo "库中数据已存在" $table_names
        fi
done

    sleep 2
 for dirlist in $dirlists
 do
        echo $dirlist
	plat=`echo ${dirlist} | awk -F_ '{print $2}'`
	svr_id=`echo ${dirlist} | awk -F_ '{print $3}'`
	client_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select client_id from game_info.information where dir='$dirlist'"|sed -n '2p')
	name=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select names from game_info.information where dir='$dirlist'"|sed -n '2p')
	start_time=$(mysql -u${username} -h${host} -p${password} -P$port -e "set names utf8;select start_time from game_info.information where dir='$dirlist'"|sed -n '2p')
	Time=`date +"%Y-%m-%d %H:%M:%S"`
        #client_id=$(mysql -u${username} -h${host} -p${password} -P$port -e "select client_id from game_info.information where dir='$i'"|sed -n '2p')
        echo $client_id
        salt "$client_id" game1.state start $dirlist
sleep 2
        #salt "$client_id" game1.state restart $dirlist
        salt "$client_id" game1.state status $dirlist
        #result=$(salt "$client_id" cmd.run "grep -w connect /home/enjoymi/${dirlist}/prod_sgzj_server/bin/log/sgzj-socialserver.${dates_tmp}.log"|sed -n '2,$p')
        result1=$(salt "$client_id" cmd.run "grep -E 'listen|connect' /home/enjoymi/${dirlist}/prod_sgzj_server/bin/log/sgzj-socialserver.${dates_tmp}.log"|head -n 14)

        if [[ ${result1} =~ failed ]];then
		stat="Stoped"
		social_stat="Connect Fail"
	else
		stat="Running"
		social_stat="Connect Success"
	fi
	result="新区${dirlist} ${name} status: ${stat}
	\n
	SocialServer:${social_stat}
	${result1}
	\n
	新服对外时间: ${start_time} 10:00:00
	邮件发送时间: ${Time}
	"
        if [[ $result =~ failed ]];then
            echo "发送邮件,启动失败"
            #echo "$result" |mail -s "$dates---$dirlist---$client_id" $mail_whos
            echo -e "${result1}" |mail -s "三国战纪2新区${plat}_${svr_id}启动状态:失败" $mail_whos
        else
            echo "发送邮件,启动成功"
            echo -e "$result" |mail -s "三国战纪2新区${plat}_${svr_id}启动状态:成功" $mail_whos
        fi

    done
fi



