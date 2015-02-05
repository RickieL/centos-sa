#!/bin/bash

## 该脚本需要以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

export LANG="en_US.UTF-8"
export PATH=$PATH

PWDir=$(dirname $(cd $(dirname $0) ; pwd))

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
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3690 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
" > /etc/sysconfig/iptables

## 新增普通用户
id yongfu >/dev/null 2>&1
if [ $? -ne 0 ] ; then
    sudo useradd yongfu
    sudo sed  -i '98a yongfu   ALL=(ALL)   NOPASSWD: ALL' /etc/sudoers
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
-e 's/PasswordAuthentication yes/PasswordAuthentication no/' \
-e 's/#UseDNS yes/UseDNS no/' \
/etc/ssh/sshd_config

## 配置证书
mkdir -p /home/yongfu/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwQ4/fp7rU9G28RVyqr4v7nXz0aXPf4DGRKRbrXH+CxNChSv6OlyVWjIpRBbMosrvHP5jWSFXEFTWeqACTqmuPaLDwrjqJycIrSvocEpK0qYHEnOnT4SZoudYzV2E9gg8epTkfUv2C3WU8Mu/PgbXMokG077ZN4OgTe8rov7CDfRdPfaeU71woSahvAC5/dKAYemXzcmpBREJiowOQDYjuD177m5obuYvwiNuhPrFIPkzk0QZsGiLxW1gxfYxUsM3ebdVVeTNle6bnlXrlBcy/giNtoX/70KGkhFp5k3wyviTnp5EdiEGnSni+OqzPCkP7gqqTCVNACJk9kVwHkNU3 yongfu@yfmac.local' >> /home/yongfu/.ssh/authorized_keys
chown yongfu:yongfu -R /home/yongfu/.ssh
chmod 700 /home/yongfu/.ssh
chmod 600 /home/yongfu/.ssh/authorized_keys

## 标准化目录
mkdir -p /opt/app /data/www/test /data/logs/nginx /data/logs/php /tmp/phpsession /data/svnserver
chown www:www -R /data/www/test  /data/logs /tmp/phpsession

mkdir -p /data/mysql /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /data/mysql  /var/lib/mysql /var/run/mysqld

# 根据对应的参数，重启后自动安装
if [ $# -ne 0 ]; then
    arg=$@
    for i in $arg
    do
        if [ -f $PWDir/bin/install-$i.sh ] ; then
            echo "$PWDir/bin/install-$i.sh >$PWDir/logs/$i.log 2>$PWDir/logs/$i.err & " >> /etc/rc.local
            echo "sleep 2"  >> /etc/rc.local
        fi
    done
fi

echo "$PWDir/bin/clean.sh" >> /etc/rc.local

reboot
