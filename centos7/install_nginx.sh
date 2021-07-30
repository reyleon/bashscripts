# See http://nginx.org/en/linux_packages.html#RHEL-CentOS

install_nginx() {
  # Install the prerequisites
  yum -y install yum-utils

  # To set up the yum repository, create the file named /etc/yum.repos.d/nginx.repo
  echo '[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
' > /etc/yum.repos.d/nginx.repo

  # Or Install Nginx by the following command
  # rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
  # yum -y install nginx

  # By default, the repository for stable nginx packages is used.
  # If you would like to use mainline nginx packages,
  # run the following command:
  # sudo yum-config-manager --enable nginx-mainline
  yum -y install nginx

}
