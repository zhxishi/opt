# coding: utf-8 
# 查询域名证书到期情况

import re
import time
import subprocess
import os
import sys
from datetime import datetime
from io import StringIO
from subprocess import check_output

url = sys.argv[1]

def main(domain):
    f = StringIO()
    comm = f"curl -Ivs https://{domain} --connect-timeout 30"

    result = subprocess.getstatusoutput(comm)
    f.write(result[1])

    m = re.search('start date: (.*?)\n.*?expire date: (.*?)\n.*?common name: (.*?)\n.*?issuer: CN=(.*?)\n', f.getvalue(), re.S)
    start_date = m.group(1)
    expire_date = m.group(2)
    common_name = m.group(3)
    issuer = m.group(4)

    # time 字符串转时间数组
    start_date = time.strptime(start_date, "%b %d %H:%M:%S %Y GMT")
#    start_date_st = time.strftime("%Y-%m-%d %H:%M:%S", start_date)
    start_date_st = time.strftime("%Y-%m-%d", start_date)
    # datetime 字符串转时间数组
    expire_date = datetime.strptime(expire_date, "%b %d %H:%M:%S %Y GMT")
#    expire_date_st = datetime.strftime(expire_date,"%Y-%m-%d %H:%M:%S")
    expire_date_st = datetime.strftime(expire_date,"%Y-%m-%d")

    # 剩余天数
    remaining = (expire_date-datetime.now()).days

    print ('*'*15,domain,'*'*15)
    print ('域名:', domain)
    print ('通用名:', common_name)
    print ('证书有效期:', start_date_st+'—'+expire_date_st)
    print (f'证书剩余时间: {remaining}天')
    print ('颁发机构:', issuer)
    print ("\n")


    time.sleep(0.5)


if __name__ == "__main__":
#    domains = ['dl-test.enjoymi.com','pre.enjoymi.com','passport-pub.enjoymi.com']
#    domains = ['dl-test.enjoymi.com','pre.enjoymi.com','passport-pub.enjoymi.com','newdevice-pub.enjoymi.com','sgzj-pub.enjoymi.com','sdkcenter-pub.enjoymi.com','sdkcenter-beta.enjoymi.com','test2.sdkcenter.enjoymi.com','zentao.enjoymi.com','svnserver.enjoymi.com','external.land.enjoymi.com','external2.land.enjoymi.com','external.enjoymi.com','audit.land.enjoymi.com','tsgzj.enjoymi.com','helps.land.enjoymi.com','client_upload2.land.enjoymi.com','video2.land.enjoymi.com','gift2.land.enjoymi.com','opendev.enjoymi.com','device.land.enjoymi.com','passport.land.enjoymi.com','newdevice.land.enjoymi.com','gift.land.enjoymi.com','service.land.enjoymi.com','tdevice.enjoymi.com','tgiftcode_tool.enjoymi.com','tgiftcode.enjoymi.com','trans.sgzj.enjoymi.com','transfer.sgzj.enjoymi.com','download.webtest.enjoymi.com','hlbres.webtest.enjoymi.com','hlb.webtest.enjoymi.com','hlbapi.webtest.enjoymi.com','test.sdkcenter.enjoymi.com','sgzj1.enjoymi.com','gift.sgzj2.enjoymi.com','test2.sgzj.enjoymi.com','small.enjoymi.com','newdevice.enjoymi.com','dev.dl.enjoymi.com','dcheck.enjoymi.com','devops.enjoymi.com','company.enjoymi.com','device.enjoymi.com','sdkcenter.enjoymi.com','tpassport.enjoymi.com','passport.enjoymi.com','track.sgzj.enjoymi.com','sgzj.enjoymi.com','webtest.enjoymi.com','message.enjoymi.com','check.enjoymi.com','gift.sgzj.enjoymi.com','dl.enjoymi.com','intr.enjoymi.com','m.enjoymi.com','games.enjoymi.com','activity.enjoymi.com','hk.test1.enjoymi.com','xm.test1.enjoymi.com','hk.paysummary.enjoymi.com','appstore1.sgzj.enjoymi.com','test1.sgzj.enjoymi.com','www.enjoymi.com','game.enjoymi.com'] 
    domains = [url]
#    domains = check_output(['cat',''])
    for domain in domains:
        main(domain)
