#!/bin/bash

CUR_DIR=$(pwd)

#### Install lib
yum install epel-release
yum install gcc gcc-c++ openssl-devel
yum install openssl-devel geoip-devel openssl-devel gperftools-devel jemalloc-devel gd-devel
yum install libatomic_ops-devel  libatomic 

#### Install Luagit
cd $CUR_DIR
tar xf LuaJIT-2.0.4.tar.gz
cd LuaJIT-2.0.4
make
make install

echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig 

LINE=`grep LUAJIT /etc/profile | wc -l`
if [ $LINE -lt 1 ]; then
cat >> /etc/profile <<EOF

export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.0
EOF
else
echo "ok"
fi


#### Install pcre
cd $CUR_DIR
tar xf pcre-8.38.tar.bz2
cd pcre-8.38
./configure --prefix=/usr/
make
make install

#### Install nginx
cd $CUR_DIR
tar xf lua-nginx-module_v0.10.6.tar.gz
tar xf tengine-2.1.2.tar.gz
tar xf ngx_devel_kit_v0.3.0.tar.gz
tar xf echo-nginx-module_v0.60.tar.gz 
tar xf form-input-nginx-module_v0.12.tar.gz 
tar xf redis2-nginx-module_v0.13.tar.gz 


cd tengine-2.1.2
./configure   \
--prefix=/opt/nginx   \
--add-module=../lua-nginx-module-0.10.6      \
--add-module=../ngx_devel_kit-0.3.0      \
--add-module=../echo-nginx-module-0.60    \
--add-module=../form-input-nginx-module-0.12    \
--add-module=../redis2-nginx-module-0.13    \
--with-pcre     \
--with-pcre-jit     \
--with-http_ssl_module    \
--with-http_realip_module    \
--with-http_image_filter_module    \
--with-http_addition_module    \
--with-http_geoip_module    \
--with-http_sub_module    \
--with-http_gunzip_module    \
--with-http_gzip_static_module    \
--with-http_secure_link_module     \
--with-http_degradation_module    \
--with-http_stub_status_module    \
--with-google_perftools_module    \
--with-luajit-lib=/usr/local/lib  \
--with-luajit-inc=/usr/local/include/luajit-2.0 \
--with-jemalloc    \
--with-libatomic     
make  -j2 && make install

#### Waf rule
cd $CUR_DIR
tar xf waf.tar
cat  waf/nginx.conf > /opt/nginx/conf/nginx.conf
mv waf /opt/nginx/conf/
