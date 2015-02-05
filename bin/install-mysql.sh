#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
PWDir=$(dirname $(cd $(dirname $0) ; pwd))
version="56-5.6.22-rel71.0.el6.x86_64"
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 删除自动安装设置
sed -i /install-mysql.sh/d /etc/rc.local

## 到包根目录
cd $PWDir

## 下载软件包
wget -q http://share.huikaiche.com/sa/Percona-Server-client-$version.rpm
wget -q http://share.huikaiche.com/sa/Percona-Server-server-$version.rpm
wget -q http://share.huikaiche.com/sa/Percona-Server-shared-$version.rpm

## 安装
if [ -f $PWDir/Percona-Server-shared-$version.rpm ]; then
    rpm -ivh $PWDir/Percona-Server-server-$version.rpm $PWDir/Percona-Server-client-$version.rpm     $PWDir/Percona-Server-shared-$version.rpm
fi

## 配置
/bin/cp -f $PWDir/conf/my.cnf /etc/my.cnf
/usr/bin/mysql_install_db --defaults-file=/etc/my.cnf --user=mysql

##
chown -R mysql:mysql /data/mysql

# 启动
/etc/init.d/mysql start
sleep 10

/usr/bin/mysql -u root  -e "delete from mysql.user where user=''" &>/dev/null
/usr/bin/mysqladmin -u root password "pass123"  &>/dev/null
/usr/bin/mysqladmin -u root -h 127.0.0.1 password "pass123" &>/dev/null
/usr/bin/mysql -u root -ppass123 -e "delete from mysql.user where password=''" &>/dev/null

## 开机启动：
chkconfig --add mysql

echo "\n ...... mysql 安装成功！\n"
