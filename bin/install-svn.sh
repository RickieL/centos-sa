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

## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 删除自动安装设置
sed -i /install-svn.sh/d /etc/rc.local

## 初始化svn库
svnadmin create /data/svn

## 修改svn配置文件
sed -i -e 's/# anon-access = read/anon-access = none/' \
-e 's/# auth-access = write/auth-access = write/' \
-e 's/# password-db = passwd/password-db = passwd/' \
-e 's/# realm = My First Repository/realm = svn/' \
/data/svn/conf/svnserve.conf


## 设置用户权限
echo "
[/]
$V_USER = rw
* = r " >> /data/svn/conf/authz

## 设置用户密码
echo "$V_USER = $V_PASS" >> /data/svn/conf/passwd

## 启动svn
svnserve -d -r /data/svn

## 开机启动
echo "svnserve -d -r /data/svn" >> /etc/rc.local

echo "\n ...... svn 安装配置成功！\n"
