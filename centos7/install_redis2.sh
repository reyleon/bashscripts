# See http://rpms.remirepo.net/

install_redis() {
  rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
  yum --enablerepo=remi -y install redis
}
