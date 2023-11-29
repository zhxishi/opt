#! /bin/bash
#auther:zhaxishi
READ_COLOR='\E[1;31m'
RES='\E[0m'
DOMIN=/root/test.txt
num1=0
echo -e "$READ_COLOR+++++++++++开始扫描端口+++++++++++++=$RES"
#遍历/root/test.txt文件中的ip地址，并将结果写入/root/namap.txt文件内
for i in $(cat $DOMIN)
do
    #nmap -sS $i |awk 'NR>2{print}'|sed '2d;3d;$d' >> nmap.txt
    telnet ${i} 443 >> telnet.txt
##统计遍历次数
    num1=`expr $num1 + 1`
done
#判断是否成功。并打印遍历次数
if [ $? -eq 0 ];then
   cp -f /root/telnet.txt /root/nmap.txt.bak
   echo -e  "$READ_COLOR+++++++++++端口扫描完毕+++++++++++++=$RES"
   echo -e "$EAD_COLOR+++总共扫描了$num1个IP地址+++++++=$RES"
   cat /dev/null > /root/telnet.txt
else
   echo "faile"
fi
