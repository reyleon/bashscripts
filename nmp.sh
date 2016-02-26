#!/bin/bash
# MySQL+PHP+NGINX INSTALL for centos6.7
# author: reyleon
# date: 2015/12/08

printout=${0}.$(date "+%Y%m%d%H%M%S").log
fifofile=${$}.fifo
mkfifo $fifofile;cat $fifofile | tee $printout &
exec 1>$fifofile
exec 2>&1

cwd=$(cd $(dirname $0); pwd)
yum -y install epel-release gcc gcc-c++

nginx_install_func() {
# --*-- NGINX 安装 BEGIN --*--
# 参考页面: https://www.nginx.com/resources/admin-guide/installing-nginx-open-source/

nginx_version=1.8.0
nginx_installprefix=/usr/local/nginx
groupadd -g 80 www
useradd -g www -u 80 -M -s /sbin/nologin www
yum -y install pcre pcre-devel openssl openssl-devel
cd $cwd && \
rm -rf nginx-${nginx_version}
if [ ! -f "nginx-${nginx_version}.tar.gz" ];then
    wget http://nginx.org/download/nginx-${nginx_version}.tar.gz || {
        echo "Download nginx-${nginx_version}.tar.gz error"
        exit 1
    }
fi
tar xf nginx-${nginx_version}.tar.gz && \
cd nginx-${nginx_version} && \
./configure \
--prefix=$nginx_installprefix \
--user=www \
--group=www \
--with-http_ssl_module \
--with-http_stub_status_module && \
make && make install
if [ $? -ne 0 ];then
    echo "nginx install error"
    exit 1
fi

# --*-- NGINX 安装 END --*--
}

mysql_install_func()
{
# --*--   MYSQL 安装 BEGIN --*--
# 参考页面,MySQL Source-Configuration Options:
# http://dev.mysql.com/doc/refman/5.6/en/source-configuration-options.html

mysql_version=5.6.27
mysql_installprefix=/usr/local/mysql
mysql_dataprefix=/var/lib/mysql
yum -y install openssl openssl-devel zlib zlib-devel cmake ncurses ncurses-devel
cd $cwd && \
rm -rf mysql-${mysql_version}
if [ ! -f "mysql-${mysql_version}.tar.gz" ];then
    wget http://downloads.mysql.com/archives/get/file/mysql-${mysql_version}.tar.gz || {
        echo "Downlod mysql-${mysql_version}.tar.gz error"
        exit 1
    }
fi
tar xf mysql-${mysql_version}.tar.gz &&
cd mysql-${mysql_version} && \
cmake . \
-DCMAKE_INSTALL_PREFIX=$mysql_installprefix \
-DMYSQL_DATADIR=$mysql_dataprefix \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_SSL=yes && \
make && make install
if [ $? -ne 0 ];then
    echo "mysql install error"
    exit 1
fi

groupadd -g 27 mysql
useradd -g mysql -u 27 -M -s /sbin/nologin mysql
cp -a $mysql_installprefix/support-files/my-default.cnf /etc/my.cnf
cp -a $mysql_installprefix/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
cd $mysql_installprefix && scripts/mysql_install_db --user=mysql --datadir=$mysql_dataprefix
chown -R mysql:mysql $mysql_installprefix $mysql_dataprefix

# --*--   MYSQL 安装 END --*--

}

php_install_func()
{
# --*--   PHP 安装 BEGIN --*--
# 参考页面
# 核心配置选项列表: http://php.net/manual/zh/configure.about.php
# 扩展库列表: http://php.net/manual/zh/extensions.membership.php

php_version=7.0.0
php_installprefix=/usr/local/php
yum -y install autoconf automake libtool re2c flex bison \
gd gd-devel libpng libpng-devel libjpeg libjpeg-devel \
zlib zlib-devel libxml2 libxml2-devel bzip2 bzip2-devel libcurl libcurl-devel mcrypt libmcrypt libmcrypt-devel \
mhash mhash-devel openssl openssl-devel readline readline-devel \
gettext gettext-devel
groupadd -g 80 www
useradd -g www -u 80 -M -s /sbin/nologin www
cd $cwd && \
rm -rf php-${php_version}
if [ ! -f "php-${php_version}.tar.gz" ];then
    wget http://cn2.php.net/distributions/php-${php_version}.tar.gz || {
        echo "Download php-${php_version}.tar.gz error"
        exit 1
    }
fi
tar xf php-${php_version}.tar.gz && \
cd php-${php_version} && \
./configure --prefix=$php_installprefix \
--with-config-file-path=/etc \
--with-fpm-user=www \
--with-fpm-group=www \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-freetype-dir \
--with-libxml-dir \
--with-openssl \
--with-zlib \
--with-bz2 \
--with-curl \
--with-mhash \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-gettext \
--enable-mysqlnd \
--enable-cgi \
--enable-fpm \
--enable-ftp \
--enable-pcntl \
--enable-shmop \
--enable-soap \
--enable-zip \
--enable-sockets \
--enable-bcmath \
--enable-mbstring && \
make && make install
if [ $? -ne 0 ];then
    echo "php install error"
    exit 1
fi

cp ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm
cp ./php.ini-production /etc/php.ini
cp $php_installprefix/etc/{php-fpm.conf.default,php-fpm.conf}
[ -d "$php_installprefix/etc/php-fpm.d" ] && {
    for f in $php_installprefix/etc/php-fpm.d/*;do
        cp "$f" "${f//.default/}"
    done
}
# --*--   PHP 安装 END   --*--
}

nginx_install_func
mysql_install_func
php_install_func

echo "finish"
sleep 2;rm -f $fifofile
