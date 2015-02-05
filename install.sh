#!/bin/bash

## 该脚本需要以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

export LANG="en_US.UTF-8"
export PATH=$PATH

## 获取github上的脚本
rm -rf centos-sa-master
yum -y install unzip wget
wget https://github.com/RickieL/centos-sa/archive/master.zip
unzip master.zip
rm -f master.zip
cd centos-sa-master

PWDir=$(pwd)

mkdir $PWDir/logs

## 设置hostname到hosts文件
echo "127.0.0.1  $HOSTNAME " >> /etc/hosts

## 语言设置为英文
sed -i 's/zh_CN.UTF-8/en_US.UTF-8/' /etc/sysconfig/i18n

## 关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

## 修改 ulimit 配置
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

## 更新系统
yum -y update

## 安装epel源
rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
sed -i '8a priority=11' /etc/yum.repos.d/epel.repo
yum makecache

## 基础环境软件
yum -y install curl wget man vim yum-priorities ntpdate make gcc subversion zlib-devel openssl-devel  gcc-c++ zip unzip autoconf automake openssl pcre-devel gd compat-glibc compat-glibc-headers cpp freetype freetype-devel libjpeg libjpeg-devel  libpng libpng-devel ncurses ncurses-devel libtool libtool-ltdl libtool-ltdl-devel  libxml2 libxml2-devel curl-devel curl libcurl-devel bison flex gmp gmp-devel bzip2-devel file libXpm libXpm-devel re2c libmcrypt-devel.x86_64 libmcrypt.x86_64 rsync git


## ntp时间同步
echo '10 7 * * * /usr/sbin/ntpdate cn.pool.ntp.org' >> /var/spool/cron/root
/usr/sbin/ntpdate cn.pool.ntp.org >/dev/null 2>&1

sleep 3

$PWDir/bin/sys-init.sh $@
