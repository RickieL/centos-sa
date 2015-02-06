#!/bin/bash

CurDir=$(dirname $0)
if [ -f $CurDir/confile ]; then
    source $CurDir/confile
else
    echo "配置文件没有生成，请检查！"
    exit 1
fi

export LANG=$LANG
export PATH=$PATH

InstallDir=/data/www/pma
version=4.3.9-all-languages
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

cd $PWDir
wget -q http://share.huikaiche.com/sa/phpMyAdmin-$version.zip
unzip phpMyAdmin-$version.zip >/dev/null 2>&1
mv phpMyAdmin-$version $InstallDir

rm -rf $InstallDir
cp -f $PWDir/conf/nginx_phpmyadmin.conf /opt/app/nginx/conf/conf.d/nginx_phpmyadmin.conf
cp -f $PWDir/conf/config.default.php $InstallDir/libraries/config.default.php

chown www:www -R $InstallDir

echo "\n ...... phpmyadmin 安装成功！\n"
