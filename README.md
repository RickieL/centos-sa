# centos-sa
centos系统初始化及nmp一键安装脚本

## 安装
```
默认安装：
curl -sk https://raw.githubusercontent.com/RickieL/centos-sa/master/install.sh | sh -s " -N -M -P "

自定义安装：
curl -sk https://raw.githubusercontent.com/RickieL/centos-sa/master/install.sh | sh -s " -u myname -p mypass -N -M -P -S "

其中:
-u 指定用户名
-p 指定密码
-N 表示安装nginx
-M 表示安装MySQL
-P 表示安装php
-A 表示安装phpMyAdmin
-S 表示安装svn

不需要安装的项目，去掉其选项就可以，如上的命令，去掉了phpMyAdmin的安装
```



## todo-list
- phpmyadmin
- √ 安装脚本
- √ 编译版，全部从线上下载软件包
- ~~安装版，其中安装版不需要进行编译，直接rpm包安装~~
- √ 参数选择安装需要的包  nginx mysql php svn pma
- √ 分成2个脚本，系统初始化脚本和nmp安装脚本
- 默认vim的配置文件
- 默认bashrc配置
- √ 应用打包脚本, 需要清理日志
- √ 默认普通用户为： yongfu 默认密码：pass123
- √ 可自己配置用户  -u myname -p mypass
- ~~也可以跳过用户设置和ssh配置, 为已经设置了普通用户和配置了ssh的用户准备~~
- √ 全局配置文件 bin/confile, 由gen-confile.sh生成

## 注意事项
// 在虚拟机中，如果解压的时候，出现时间戳错误
// 在还没安装ntpdate的情况下，这样设置时间：  
DateTime=$(date +"%Y-%m-%d %H:%I:%S" -d "1 year")  
date -s "$DateTime"
