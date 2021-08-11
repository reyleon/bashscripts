install_proxychains() {
  proxychains_version=4.15
  yum -y install gcc wget
  tempdir=$(mktemp -d)
  cd $tempdir
  wget https://github.com/rofl0r/proxychains-ng/archive/refs/tags/v${proxychains_version}.tar.gz
  tar xf v${proxychains_version}.tar.gz
  cd proxychains-ng-${proxychains_version}
  ./configure && make && make install
  cp src/proxychains.conf /etc/
}
