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

## 删除自动安装设置
sed -i /install-pma.sh/d /etc/rc.local

InstallDir=/data/www/pma
version=4.3.9-all-languages

## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

cd $PWDir
if [ ! -f phpMyAdmin-$version.zip ]; then
    wget -q http://share.huikaiche.com/sa/phpMyAdmin-$version.zip
fi
unzip phpMyAdmin-$version.zip >/dev/null 2>&1
mv phpMyAdmin-$version $InstallDir

cp -f $PWDir/conf/nginx_phpmyadmin.conf /opt/app/nginx/conf/conf.d/nginx_phpmyadmin.conf
cp -f $PWDir/conf/config.default.php $InstallDir/libraries/config.default.php

chown www:www -R $InstallDir

## 当iptable没有设置时，在此设置
grep '--dport 8080' /etc/sysconfig/iptables >/dev/null 2>&1
if [ $? -ne 0 ]; then
    sed -i '10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
fi

## 重启nginx，是新配置生效
service nginx restart

echo "phpmyadmin 安装成功！"
