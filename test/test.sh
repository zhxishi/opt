#!/bin/bash
script_name=`basename $0`
script_abs_name=`readlink -f $0`
script_path=`dirname $script_abs_name`
timestamp=`date +%s`
username=`whoami`
#这是一个测试