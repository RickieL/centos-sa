#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
PWDir=$(dirname $(cd $(dirname $0) ; pwd))
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 删除自动安装设置
sed -i /sleep/d /etc/rc.local
sed -i /clean.sh/d /etc/rc.local
