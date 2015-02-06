#!/bin/bash

PWDir=$(dirname $(cd $(dirname $0) ; pwd))
V_NGINX=none
V_MYSQL=none
V_PHP=none
V_PMA=none
V_SVN=none
V_USER=yongfu
V_PASS=pass123

LANG="en_US.UTF-8"
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 用法
usage()
{
    echo "*参数错误：
          Usage: `basename $0` [-u username] [-p password] [-P] [-M] [-N] [-A] [-S]
          "
    exit 1
}

while getopts :u:p:PMNAS OPTION
do
    case $OPTION in
        u)
            V_USER=$OPTARG
            ;;
        p)
            V_PASS=$OPTARG
            ;;
        P)
            V_PHP=y
            ;;
        M)
            V_MYSQL=y
            ;;
        N)
            V_NGINX=y
            ;;
        A)
            V_PMA=y
            ;;
        S)
            V_SVN=y
            ;;
        \?)
            usage
            ;;
    esac
done

echo "
PWDir=$PWDir
V_USER=$V_USER
V_PASS=$V_PASS
V_PHP=$V_PHP
V_MYSQL=$V_MYSQL
V_NGINX=$V_NGINX
V_PMA=$V_PMA
V_SVN=$V_SVN
LANG=$LANG
PATH=$PATH
" > $PWDir/bin/confile
