# centos-sa
centos系统初始化及nmp一键安装脚本

## 安装
```
curl -sk https://raw.githubusercontent.com/RickieL/centos-sa/master/install.sh | sh -s nginx mysql php svn
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
- √ 默认普通用户为： yongfu
- 可自己配置用户  -u yongfu -k my-rsa-key.pub -p pass123
- 也可以跳过用户设置和ssh配置, 为已经设置了普通用户和配置了ssh的用户准备  -s
- 全局配置文件

## 注意事项
// 在虚拟机中，如果解压的时候，出现时间戳错误
// 在还没安装ntpdate的情况下，这样设置时间：  
DateTime=$(date +"%Y-%m-%d %H:%I:%S" -d "1 year")  
date -s "$DateTime"
