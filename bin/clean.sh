#!/bin/bash

CurDir=$(dirname $0)

if [ -f $CurDir/confile ]; then
    source $CurDir/confile
else
    echo "配置文件没有生成，请检查！"
    exit 1
fi

export $LANG
export $PATH

CsaDir=$(dirname $PWDir)

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
