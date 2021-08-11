# See https://subversion.apache.org/packages.html
# See http://opensource.wandisco.com/centos/7/

install_subversion() {

  echo '[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/7/svn-1.14/RPMS/$basearch/
enabled=1
gpgcheck=0
' > /etc/yum.repos.d/wandisco-svn.repo

  yum -y install subversion

}
