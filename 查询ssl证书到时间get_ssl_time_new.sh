#!/bin/bash
cd /opt/ssl_time
cat /dev/null > result-success.txt
cat /dev/null > result-failed.txt
# 脚本所在目录即脚本名称
script_dir=$( cd "$( dirname "$0"  )" && pwd )
script_name=$(basename ${0})
echo $script_dir
echo $script_name
cat ${script_dir}/domain.list |while  read domain
do
  #echo "------------------------"
  #echo $domain
  endtime=`echo |timeout 5 openssl s_client -servername $domain  -connect $domain\:443 2>/dev/null| openssl x509 -noout -dates |grep 'After'` >/dev/null 2>&1
  if [ $? -eq 0 ]
  then
      #echo $endtime
      ssl_time=`echo $endtime |grep 'After'| awk -F '=' '{print $2}'| awk -F ' +' '{print $1,$2,$3,$4,$5}'`
      #echo $ssl_time
      END_TIME=`echo $endtime |grep 'After'| awk -F '=' '{print $2}'| awk -F ' +' '{print $1,$2,$4}'`
      END_TIME1=$(date +%s -d "$END_TIME") #将日期转化为时间戳
      NOW_TIME=$(date +%s -d "$(date | awk -F ' +'  '{print $2,$3,$6}')") #将目前的日期也转化为时间戳

      Available_time=$(($(($END_TIME1-$NOW_TIME))/(60*60*24))) # 到期时间减去目前时间再转化为天数
      #echo $Available_time
      #echo "END_TIME1" $END_TIME1
      ##将到期的ssl时间换成可读的的时间格式 
      Available_day=$(date -d @"$END_TIME1" "+%Y-%m-%d")
      #echo "Available_day"  $Available_day
      echo "域名：" $domain  "到期时间： "$ssl_time "剩余时间："$Available_time
      echo "域名：" $domain  "到期时间： "$ssl_time "剩余时间："$Available_time >>  ${script_dir}/result-success.txt
      echo "$domain,$ssl_time,$Available_time" >> ${script_dir}/result.txt

  else
      echo "$domain 无SSL域名证书"
      echo "$domain 无SSL域名证书" >> ${script_dir}/result-failed.txt
  fi
done
