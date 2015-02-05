#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
PWDir=$(cd $(dirname $0) ; pwd)
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi



echo "\n ...... phpmyadmin 安装成功！\n"
