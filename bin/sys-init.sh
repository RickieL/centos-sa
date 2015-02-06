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

## 修改 iptables 设置
echo "# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
" > /etc/sysconfig/iptables

if [ $V_NGINX == 'y' ]; then
    sed -i '10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT' /etc/sysconfig/iptables
fi
if [ $V_PMA == 'y' ]; then
    sed -i '10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
fi
if [ $V_SVN == 'y' ]; then
    sed -i '10a -A INPUT -m state --state NEW -m tcp -p tcp --dport 3690 -j ACCEPT' /etc/sysconfig/iptables
fi


## 新增普通用户
id $V_USER >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    useradd $V_USER
    echo $V_PASS | passwd  -stdin $V_USER   #设置用户密码
    sed  -i "98a $V_USER   ALL=(ALL)   NOPASSWD: ALL" /etc/sudoers
fi

## 新建www用户
id www >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    groupadd  www -g 600
    useradd -g  www   -u 600  -s /sbin/nologin  www
fi

## 新建mysql用户
id mysql >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    groupadd  mysql -g 27
    useradd -g  mysql   -u 27  -s /sbin/nologin  mysql
fi

## 修改ssh配置
sed  -i -e 's/#PermitRootLogin yes/PermitRootLogin no/'  \
-e 's/#UseDNS yes/UseDNS no/' \
/etc/ssh/sshd_config


## 标准化目录
mkdir -p /opt/app /data/www/test /data/logs/nginx /data/logs/php /tmp/phpsession /data/svnserver
chown www:www -R /data/www/test  /data/logs /tmp/phpsession

mkdir -p /data/mysql /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /data/mysql  /var/lib/mysql /var/run/mysqld

# 根据对应的参数，重启后自动安装
if [ $V_NGINX == 'y' ]; then
    echo "$PWDir/bin/install-nginx.sh >$PWDir/logs/nginx.log 2>$PWDir/logs/nginx.err & " >> /etc/rc.local
    echo "sleep 2"  >> /etc/rc.local
if
if [ $V_MYSQL == 'y' ]; then
    echo "$PWDir/bin/install-mysql.sh >$PWDir/logs/mysql.log 2>$PWDir/logs/mysql.err & " >> /etc/rc.local
    echo "sleep 2"  >> /etc/rc.local
fi
if [ $V_PHP == 'y' ]; then
    echo "$PWDir/bin/install-php.sh >$PWDir/logs/php.log 2>$PWDir/logs/php.err & " >> /etc/rc.local
    echo "sleep 2"  >> /etc/rc.local
fi
if [ $V_PMA == 'y' ]; then
    echo "$PWDir/bin/install-pma.sh >$PWDir/logs/pma.log 2>$PWDir/logs/pma.err & " >> /etc/rc.local
    echo "sleep 2"  >> /etc/rc.local
fi
if [ $V_SVN == 'y' ]; then
    echo "$PWDir/bin/install-svn.sh >$PWDir/logs/svn.log 2>$PWDir/logs/svn.err & " >> /etc/rc.local
    echo "sleep 2"  >> /etc/rc.local
fi

echo "$PWDir/bin/clean.sh" >> /etc/rc.local

reboot
