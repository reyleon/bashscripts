# See http://rpms.remirepo.net/
# See https://mirrors.tuna.tsinghua.edu.cn/remi/

install_redis() {
    # 安装remi yum仓库
    # For CentOS7
    rpm -Uvh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm

    # 安装redis
    yum --enablerepo=remi -y install redis

}
