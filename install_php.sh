# please See https://webtatic.com/packages/php72/

install_php() {
    yum -y install epel-release
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && \
    yum -y install php72w-common php72w-devel php72w-fpm php72w-cli php72w-opcache php72w-gd php72w-mbstring \
    php72w-mysqlnd php72w-bcmath

    return $?

}
