#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
CsaDir=$($(dirname $(dirname $0)))
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

if [ -f $CsaDir/master.zip ]; then
    rm -f $CsaDir/master.zip
fi

## 删除自动安装设置
sed -i /sleep/d /etc/rc.local
sed -i /clean.sh/d /etc/rc.local
