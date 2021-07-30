install_proxychains() {
    if [ -z "$PACKAGE_PATH" ];then
        echo "没有设置 PACKAGE_PATH 变量, 跳过 proxychains 的安装"
        return 1
    fi

    cd $PACKAGE_PATH
    PACKAGE_NAME=proxychains-ng-master
    if [ -f ${PACKAGE_NAME}.zip ];then
        unzip ${PACKAGE_NAME}.zip
        cd $PACKAGE_NAME
        ./configure && make && make install
        return $?
    else
        echo "没有发现 ${PACKAGE_NAME}.zip 文件"
        return 1
    fi
}
