#!/bin/bash

redis_version=3.0.5
rm -rf redis-${redis_version// /}
if [ ! -f "redis-${redis_version}.tar.gz" ];then
  wget "http://download.redis.io/releases/redis-${redis_version}.tar.gz" || {
      echo "download redis-${redis_version}.tar.gz error"
      exit 1
  }
fi
yum -y install gcc gcc-c++
tar xf redis-${redis_version}.tar.gz && \
cd redis-${redis_version} && \
make && make install
if [ $? -ne 0 ];then
  echo "redis install error"
  exit 1
fi

[ -f "src/redis-trib.rb" ] && cp src/redis-trib.rb /usr/local/bin/
cd utils
if [ -f "install_server.sh" ];then
  sh install_server.sh
  exit $?
fi

exit 0
