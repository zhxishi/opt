 1 #!/bin/bash
  2 script_name=`basename $0`
  3 script_abs_name=`readlink -f $0`
  4 script_path=`dirname $script_abs_name`
  5 timestamp=`date +%s`
  6 
  7 while read dbname;do
  8  for i in `cat idlist.txt`                                                                                                                                                                                     
  9    do
 10 mysql -uroot -pEnjoymiHdtech123 -h10.3.31.4 -e "select '${dbname}',id from ${dbname}.tbl_player where id=${i};"
 11   done
 12 done < list.txt


###由于合区所以id不一定对应区服，故需要把id和区服列表传入参数查询数据库