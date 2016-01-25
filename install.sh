#!/bin/bash

## 该脚本需要以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

export LANG="en_US.UTF-8"
export PATH=$PATH

## 更新系统
echo "[0]正在进行系统更新...."
yum -y update >/dev/null 2>&1
echo "[1]已更新系统到最新"

## 安装epel源
rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm >/dev/null 2>&1
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
sed -i '8a priority=11' /etc/yum.repos.d/epel.repo
yum makecache >/dev/null 2>&1
echo "[2]安装epel源"

## 基础环境软件
yum -y install curl wget man vim yum-priorities ntpdate make gcc subversion zlib-devel openssl-devel  gcc-c++ zip unzip autoconf automake openssl pcre-devel gd compat-glibc compat-glibc-headers cpp freetype freetype-devel libjpeg libjpeg-devel  libpng libpng-devel ncurses ncurses-devel libtool libtool-ltdl libtool-ltdl-devel  libxml2 libxml2-devel curl-devel curl libcurl-devel bison flex gmp gmp-devel bzip2-devel file libXpm libXpm-devel re2c libmcrypt-devel.x86_64 libmcrypt.x86_64 rsync git libicu-devel jemalloc libaio perl-Test-Simple perl-Time-HiRes >/dev/null 2>&1
echo "[3]安装基础软件包"

## ntp时间同步
echo '10 * * * * /usr/sbin/ntpdate cn.pool.ntp.org >/dev/null 2>&1' >> /var/spool/cron/root
/usr/sbin/ntpdate cn.pool.ntp.org >/dev/null 2>&1
echo "[4]时间同步"

## 设置hostname到hosts文件
echo "127.0.0.1  $HOSTNAME " >> /etc/hosts
echo "[5]更新hosts文件"

## 语言设置为英文
sed -i 's/zh_CN.UTF-8/en_US.UTF-8/' /etc/sysconfig/i18n
echo "[6]设置系统语言"

## 关闭selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
echo "[7]关闭selinux"

## 修改 ulimit 配置
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf
echo "[8]调整文件描述符数量"

sleep 2

## 获取github上的脚本
rm -rf centos-sa-master
wget -q https://github.com/RickieL/centos-sa/archive/master.zip
unzip master.zip  >/dev/null 2>&1
cd centos-sa-master
echo "[9]获取centos-sa源码包"

PWDir=$(pwd)

mkdir $PWDir/logs
chmod +x $PWDir/bin/*

## 具体的安装配置选项
echo "[10]生成配置文件"
$PWDir/bin/gen-confile.sh $@
echo "[11]根据配置文件，进行个性化系统初始化"
$PWDir/bin/sys-init.sh
