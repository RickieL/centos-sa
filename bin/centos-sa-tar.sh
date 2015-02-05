#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
PWDir=$(dirname $(cd $(dirname $0) ; pwd))
AppDir=$(dirname $PWDir)
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 清理不必要的文件
if [ -d $PWDir ] && [ "$PWDir" != "/" ] ; then
    rm -rf $PWDir/logs/*
    rm -rf $PWDir/*.gz
    rm -rf $PWDir/*.zip
    rm -rf $PWDir/*.rpm
fi


Version=$1

cd $AppDir
if [ "x$Version" != "x" ]; then
    File=centos-sa-$Version.tar.gz
    rm -f $File
    tar czf $File centos-sa
    rsync -av $File share.huikaiche.com::public-share/ && rm -f $File
else
    echo "需要设定版本号"
    exit 1
fi

