init_centos7_packages () {
    yum clean all
    yum makecache
    yum -y update
    yum -y install ca-certificates
    yum -y install epel-release

    # 安装remi yum仓库
    # See https://mirrors.tuna.tsinghua.edu.cn/remi/
    rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm

    yum -y install vim-enhanced net-tools lrzsz curl wget zip unzip ftp rsync chrony \
gcc gcc-c++ cmake pcre pcre-devel zlib zlib-devel openssl openssl-devel telnet setuptool dos2unix bind-utils \
tree screen ntpdate tree lsof iotop iftop htop man man-pages xz gzip bzip2 bzip2-devel \
readline readline-devel krb5-devel pam-devel gdb s3cmd jq python36 tcpdump sysstat dstat strace \
traceroute perf libnghttp2 nghttp2 libnghttp2-devel libicu

    # 安装city-fan仓库主要用于升级curl相关
    rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-2-1.rhel7.noarch.rpm

    # 升级curl
    yum --disablerepo="*" --enablerepo="city-fan*" -y install libcurl curl
    if [ $? -ne 0 ];then
        echo "升级libcurl/curl失败"
        exit 1
    fi

    # 开启时间服务
    systemctl start chronyd.service
    systemctl enable chronyd.service

}

init_centos7_configure () {
    # 设置语言为英文
    localectl set-locale LANG=en_US.utf8

    # 时间相关
    # 设置时区为UTC时间
    timedatectl set-timezone UTC
    # 设置时区为亚洲上海
    # timedatectl set-timezone Asia/Shanghai
    timedatectl set-ntp yes

    # 关闭selinux
    setenforce 0
    sed -i.bak -r 's/^\s*SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

    # 关闭postfix
    systemctl stop  postfix
    systemctl disable postfix

    # 移除firewalld
    systemctl stop firewalld
    yum -y remove firewalld-filesystem firewalld

    # 安装iptables-services
    yum -y install iptables-services

}
