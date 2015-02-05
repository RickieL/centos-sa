#!/bin/bash

export LANG="en_US.UTF-8"
export PATH=$PATH
PWDir=$(dirname $(cd $(dirname $0) ; pwd) )
InstallDir=/opt/app/php55
version=5.5.21
phpredis=phpredis-2.2.7
## 以root用户运行
user=$(whoami)
if [ $user != 'root' ] ; then
    echo "该脚本需要以root用户运行, 当前用户为 $user"
    exit 1;
fi

## 删除自动安装设置
sed -i /install-php.sh/d /etc/rc.local

## 解压文件
cd $PWDir
wget http://share.huikaiche.com/sa/php-$version.tar.gz
wget http://share.huikaiche.com/sa/$phpredis.zip
tar xzf php-$version.tar.gz
unzip $phpredis.zip

## 编译
cd php-$version
./configure  --prefix=/opt/app/php55 --with-mysql --with-pdo-mysql --with-mysqli --with-gd --with-zlib --enable-bcmath --enable-shmop --with-curl --enable-fpm --enable-mbstring --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --with-mcrypt --with-libdir=lib64 --with-freetype-dir=/usr --with-png-dir=/usr --enable-sysvmsg --enable-sysvshm --enable-sysvsem --with-gmp --with-jpeg-dir=/usr --with-libxml-dir=/usr --disable-phar --enable-exif
make && make install

## 配置
/bin/cp -f sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
/bin/cp -f $PWDir/conf/php.ini /opt/app/php55/lib/php.ini
/bin/cp -f $PWDir/conf/php-fpm.conf /opt/app/php55/etc/php-fpm.conf

## phpredis扩展
cd $PWDir/phpredis-2.2.7
/opt/app/php55/bin/phpize
./configure --with-php-config=/opt/app/php55/bin/php-config
make && make install


## 开机启动：
chkconfig --add php-fpm

## 启动：
/etc/init.d/php-fpm start

## 清理工作
cd $PWDir
rm -rf php-$version
rm -rf phpredis-2.2.7

echo "\n ...... php 安装成功！\n"
