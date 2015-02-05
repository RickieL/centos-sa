#!/bin/bash

export LANG="en_US.UTF-8" 
export PATH=$PATH
PWDir=$(cd $(dirname $0) ; pwd)
version="56-5.6.22-rel71.0.el6"
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 安装
rpm -ivh $PWDir/rpms/Percona-Server-server-56-5.6.22-rel71.0.el6.x86_64.rpm $PWDir/rpms/Percona-Server-client-56-5.6.22-rel71.0.el6.x86_64.rpm $PWDir/rpms/Percona-Server-shared-56-5.6.22-rel71.0.el6.x86_64.rpm

chown -R mysql:mysql /data/mysql

## 配置
/bin/cp -f $PWDir/conf/my.cnf /etc/my.cnf
/usr/bin/mysql_install_db --defaults-file=/etc/my.cnf --user=mysql
# /usr/bin/mysql_upgrade

## 
chown -R mysql:mysql /data/mysql

# ldconfig
/etc/init.d/mysql start
sleep 10

/usr/bin/mysql -u root  -e "delete from mysql.user where user=''"
/usr/bin/mysqladmin -u root password "pass123"


## 开机启动：
chkconfig --add mysql
