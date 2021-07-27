# See https://git-scm.com/download/linux
#
# Red Hat Enterprise Linux, Oracle Linux, CentOS, Scientific Linux, et al.
# RHEL and derivatives typically ship older versions of git.
# You can download a tarball and build from source,
# or use a 3rd-party repository such as the IUS Community Project to obtain a more recent version of git.

# See https://ius.io/setup

install_git() {
  # To enable the IUS repository on your system, install the ius-release package.
  # This package contains the IUS repository configuration and public package signing keys.
  # Many IUS packages have dependencies from the EPEL repository,
  # so install the epel-release package as well.
  yum -y install https://repo.ius.io/ius-release-el7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

  # yum repo-pkgs ius list | grep git
  # ...
  # git224.x86_64                                 2.24.4-1.el7.ius               ius
  # ...
  yum -y install git224

}