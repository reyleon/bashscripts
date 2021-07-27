# See https://rpms.remirepo.net/wizard/

install_php() {
  # Command to install the EPEL repository configuration package
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

  # Command to install the Remi repository configuration package
  yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm

  # Command to install the yum-utils package (for the yum-config-manager command)
  yum -y install yum-utils

  # You want a single version which means replacing base packages from the distribution
  # Packages have the same name than the base repository, ie php-*
  # Some common dependencies are available in remi-safe repository, which is enabled by default
  # PHP version 7.4 packages are available for RHEL 7 in remi-php74 repository
  # Command to enable the repository:
  yum-config-manager --disable 'remi-php*'
  yum-config-manager --enable   remi-php74

  # You can check the list of the enabled repositories:
  # yum repolist

  # If the priorities plugin is enabled, ensure remi-php74 have higher priority (a lower value) than base and updates
  # Command to upgrade (the repository only provides PHP):
  # yum update

  # Command to install additional packages:
  # yum install php-xxx
  # reference: https://rpms.remirepo.net/enterprise/7/php74/x86_64/repoview/
  yum -y install php

  # Command to install testing packages:
  # yum --enablerepo=remi-php74-test install php-xxx

  # Command to check the installed version and available extensions:
  php --version
  php --modules

}
