# See https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/

install_mysql() {
  # Install the prerequisites
  yum -y install yum-utils

  # Go to the download page for MySQL Yum repository at https://dev.mysql.com/downloads/repo/yum/.
  # Install the downloaded release package with the following command,
  # replacing platform-and-version-specific-package-name with the name of the downloaded package
  # https://dev.mysql.com/get/mysql80-community-release-el6-2.noarch.rpm
  rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el7-2.noarch.rpm

  # Use this command to see all the subrepositories in the MySQL Yum repository,
  # and see which of them are enabled or disabled
  # shell> yum repolist all | grep mysql
  # shell> yum repolist disabled | grep mysql
  # shell> yum repolist enabled | grep mysql

  # To install the latest release from the latest GA series, no configuration is needed.
  # To install the latest release from a specific series other than the latest GA series,
  # disable the subrepository for the latest GA series and enable the subrepository
  # for the specific series before running the installation command
  # which disable the subrepository for the 8.0 series and enable the one for the 5.7 series
  yum-config-manager --disable mysql80-community
  yum-config-manager --enable mysql57-community

  # Install MySQL by the following command
  yum -y install mysql-community-server
  yum -y install mysql-community-devel
}

