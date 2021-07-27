#!/bin/bash

# 基础目录设定
INITDIR=$(cd `dirname $0`;pwd)
ROOTDIR=$(cd $INITDIR/..; pwd)
ETC=$ROOTDIR/etc
LIB=$ROOTDIR/lib
SRC=$ROOTDIR/src
EXECTIME=$(date "+%Y%m%d%H%M%S")

# 日志
TEMPFILE=$(mktemp -u)
printout=${0}.${EXECTIME}.log
fifofile=${TEMPFILE}.fifo
mkfifo $fifofile;cat $fifofile | tee $printout &
exec 1>$fifofile
exec 2>&1

# 加载配置与安装脚本
source $LIB/init_centos7_packages.sh
source $LIB/install_mysql.sh
source $LIB/install_nginx.sh
source $LIB/install_php.sh
source $LIB/install_redis.sh
source $LIB/install_subversion.sh
source $LIB/install_proxychains.sh

# 执行系统配置
init_centos7_packages
init_centos7_configure

# 升级 BASH
unzip -o -u -d /usr/local/ $SRC/bash4418.zip
cp -af /bin/{bash,bash.$EXECTIME}
if [ -f /usr/local/bash4418/bin/bash ]; then
    ln -sf /usr/local/bash4418/bin/bash /bin/bash
fi

# 安装软件包
install_mysql
install_nginx
install_redis
install_subversion
PACKAGE_PATH=$SRC install_proxychains

# 配置
cp -af $ETC/etc/profile.d/keys.sh /etc/profile.d/
cp -af $ETC/etc/rsyslog.d/bashhist.conf /etc/rsyslog.d/
cp -af $ETC/etc/security/limits.conf /etc/security/
cp -af $ETC/etc/ssh/ssh_config /etc/ssh/
cp -af $ETC/etc/ssh/sshd_config /etc/ssh/
cp -af $ETC/etc/sysconfig/iptables /etc/sysconfig/
cp -af $ETC/etc/rc.local /etc/
cp -af $ETC/etc/sudoers /etc/
cp -af $ETC/etc/sysctl.conf /etc/
cp -af $ETC/etc/my.cnf /etc/
cp -af $ETC/etc/proxychains.conf /etc/

mkdir -pv /root/.ssh
cp -af $ETC/root/ssh/authorized_keys /root/.ssh/
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

svn --version && \
cp -af $ETC/root/subversion/{config,servers} /root/.subversion/

/sbin/sysctl -p
/usr/bin/systemctl restart sshd
/usr/bin/systemctl restart rsyslog
/usr/bin/systemctl restart crond
/usr/bin/systemctl start iptables
/usr/bin/systemctl enable iptables
