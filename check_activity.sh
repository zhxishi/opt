#!/bin/bash
#
#
# 20190315

# md5 效验文件
check_file=${1}

Warning() {
  echo
  echo -e "    \033[31m$1\033[0m"
  echo
}

Success() {
  echo -e "    \033[32m$1\033[0m"
}

Usage(){
  Warning "Usage: $0 <cheeck_file>"
}

check() {
  for i in `ls /home/enjoymi`;do
    cd /home/enjoymi/${i}
   
    while read  MD5 File;do
      New_MD5=`md5sum ${File}|awk '{print $1}'`
    
      if [ "${New_MD5}" == "$MD5" ];then
        :
      else
        echo "Error,please check!" 
        echo "${i}:
    原文件: $File 
    原MD5码: $MD5
    游戏服上该文件MD5码: $New_MD5"
      fi

     done < $1

  done 


}



if [ "$#" == "1"  ];then
  check ${check_file}
else
  Usage 
fi
