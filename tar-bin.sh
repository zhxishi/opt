#!/bin/bash
# 用来生成纯净的活动包，主要是删掉包里的prod_sgzj_client目录，更新活动包不需要这个目录。
package=$1
tar zxf ${package};
/bin/rm -rf prod_sgzj_client;
/bin/rm -rf prod_sgzj_server/bin;
tar zcf ${package} prod_sgzj_server;
/bin/rm -rf prod_sgzj_server;
