#!/usr/bin/env bash

#php_config
#php -i | grep blah
#php -m | grep blah

set -e
set -x
shopt -s expand_aliases

TMPDIR=/home/matt/src
#LIBEVENT_VER=1.4.13-stable #http://monkey.org/~provos/libevent/ 
LIBEVENT_VER=2.0.10-stable
PHP_VER=5.3.6 #http://php.net/downloads.php 
SUHOSIN_PATCH_VER=0.9.10 #http://www.hardened-php.net/suhosin/download.html 
SUHOSIN_PATCH_PHP_VER=5.3.4
SUHOSIN_VER=0.9.32.1
IMAGEMAGICK_VER=6.6.8-8 #http://www.imagemagick.org/script/download.php 
IMAGICK_VER=3.0.1 #http://pecl.php.net/package/imagick 
APC_VER=3.1.6 #http://pecl.php.net/package/APC 

if [ `uname -m` = "x86_64" ] #One can get i386 or i686, so I test the other.
then
	ARCH=64
else
	ARCH=32
fi

if [[ `cat /etc/*-release | awk '{print $1}' -` = "CentOS" ]]; then
	OS="CentOS"
elif [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
then
	OS="Ubuntu"
else
	OS="neither" # Debian is on the roadmap.
fi

cd /home/matt/src
wget "http://www.monkey.org/~provos/libevent-$LIBEVENT_VER.tar.gz"
tar xzvf "libevent-$LIBEVENT_VER.tar.gz"
cd "libevent-$LIBEVENT_VER"

if [ $OS = "CentOS" -a $ARCH -eq 64 ]; then
	./configure --libdir=/usr/lib64
else
	./configure
fi
make -j4
checkinstall --pkgname="libevent" make install

#TODO: Clean out these CentOS dependencies.
if [ $OS = "CentOS" ]; then
	yum install -y gettext rpm-build make gcc mlocate libxml2-devel bzip2-devel pcre-devel openssl-devel zlib-devel libmcrypt-devel libmhash-devel libmhash curl-devel libtidy-devel libxslt-devel libpng-devel libtool-ltdl-devel libtool make bison flex gcc patch t1lib-devel krb5-devel libexif-devel freetype-devel htop gcc-c++ libjpeg-devel aspell-devel net-snmp-devel db4-devel
else
	apt-get -y install libxml2-dev libbz2-dev libjpeg8-dev libpng12-dev libfreetype6-dev libt1-dev libmcrypt-dev libpspell-dev libtidy-dev libxslt1-dev libsnmp-dev libgs-dev
fi

cd /home/matt/src
wget -O php-$PHP_VER.tar.bz2 "http://us2.php.net/get/php-$PHP_VER.tar.bz2/from/this/mirror"
tar xjvf "php-$PHP_VER.tar.bz2"

#TODO: Check for a newer version eventually, since these probably won't apply.
#wget "http://download.suhosin.org/suhosin-patch-$SUHOSIN_PATCH_PHP_VER-$SUHOSIN_PATCH_VER.patch.gz"
#gzip -cd "suhosin-patch-$SUHOSIN_PATCH_PHP_VER-$SUHOSIN_PATCH_VER.patch.gz" | patch -d "php-$PHP_VER" -p1

cd "php-$PHP_VER"
if [ $OS = "CentOS" -a $ARCH -eq 64 ]; then
	./configure --enable-fpm --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --with-gd --with-jpeg-dir --with-pcre-regex --with-pcre-dir --with-png-dir --enable-gd-native-ttf --enable-mbstring --with-mcrypt --with-mhash --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-zip --with-pear --enable-exif --with-xmlrpc --with-curlwrappers --with-tidy --with-xsl --with-t1lib --with-openssl --with-kerberos --with-gettext --enable-exif --with-freetype-dir --libdir=/usr/local/lib --with-pspell --enable-dba --with-snmp --enable-soap --with-libdir=lib64 #the only difference is that last entry. TODO: Figure out how to not repeat all of this.
else
	./configure --enable-fpm --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --with-gd --with-jpeg-dir --with-pcre-regex --with-pcre-dir --with-png-dir --enable-gd-native-ttf --enable-mbstring --with-mcrypt --with-mhash --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-zip --with-pear --enable-exif --with-xmlrpc --with-curlwrappers --with-tidy --with-xsl --with-t1lib --with-openssl --with-kerberos --with-gettext --enable-exif --with-freetype-dir --libdir=/usr/local/lib --with-pspell --enable-dba --with-snmp --enable-soap
fi
make -j4
checkinstall make install

if [ $OS = "Ubuntu" ]; then
	apt-get -y install autoconf
else
	yum install -y autoconf
fi

if [ $OS = "CentOS" ]; then
	yum install -y libpng-devel ghostscript-devel
fi

cd /home/matt/src
wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$IMAGEMAGICK_VER.tar.bz2
tar xjvf ImageMagick-$IMAGEMAGICK_VER.tar.bz2
cd ImageMagick-$IMAGEMAGICK_VER
./configure
make -j4
checkinstall --pkgname="imagemagick" make install
ldconfig /usr/local/lib #necessary on CentOS 5, apparently.

cd /home/matt/src
wget http://pecl.php.net/get/imagick-$IMAGICK_VER.tgz 
tar xzvf imagick-$IMAGICK_VER.tgz
cd imagick-$IMAGICK_VER
phpize
./configure
make -j4
checkinstall make install

cd /home/matt/src
wget http://pecl.php.net/get/APC-$APC_VER.tgz
tar xzvf APC-$APC_VER.tgz
cd APC-$APC_VER
phpize
./configure --enable-apc
make -j4
checkinstall --pkgname="apc" make install

/bin/cp "/home/matt/src/php-$PHP_VER/php.ini-production" /usr/local/lib/php/php.ini
ln -s /usr/local/lib/php/php.ini /usr/local/lib/php.ini
mkdir /etc/php
ln -s /usr/local/lib/php/php.ini /etc/php/php.ini
/bin/cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
ln -s /usr/local/etc/php-fpm.conf /etc/php/php-fpm.conf

sed -i 's/;error_log = log\/php-fpm.log/error_log = \/var\/log\/php\/php-fpm.log/' /usr/local/etc/php-fpm.conf
sed -i 's/listen = 127.0.0.1:9000/listen = \/usr\/local\/var\/run\/php-fpm.sock/' /usr/local/etc/php-fpm.conf

#Only if we installed nginx first.
if id nginx; then
	sed -i "s/;listen.owner = nobody/listen.owner = nginx/" /usr/local/etc/php-fpm.conf
	sed -i "s/;listen.group = nobody/listen.group = nginx/" /usr/local/etc/php-fpm.conf
fi

sed -i 's/;listen.mode = 0666/listen.mode = 0600/' /usr/local/etc/php-fpm.conf

if [ $OS = "Ubuntu" ]; then
	sed -i 's/group = nobody/group = nogroup/' /usr/local/etc/php-fpm.conf #Ubuntu doesn't have a `nobody` group.
fi

sed -i 's/pm.max_children = 50/pm.max_children = 50/' /usr/local/etc/php-fpm.conf
sed -i 's/;pm.start_servers = 20/pm.start_servers = 12/' /usr/local/etc/php-fpm.conf
sed -i 's/;pm.min_spare_servers = 5/pm.min_spare_servers = 5/' /usr/local/etc/php-fpm.conf
sed -i 's/;pm.max_spare_servers = 35/pm.max_spare_servers = 20/' /usr/local/etc/php-fpm.conf
sed -i 's/;pm.max_requests = 500/pm.max_requests = 500/' /usr/local/etc/php-fpm.conf
sed -i '/;request_slowlog_timeout = 0/request_slowlog_timeout = 15/' /usr/local/etc/php-fpm.conf
sed -i '/;slowlog/ c\slowlog = /var/log/php/php-fpm.log.slow' /usr/local/etc/php-fpm.conf
sed -i 's/;pid = run\/php-fpm.pid/pid = \/var\/run\/php-fpm.pid/' /usr/local/etc/php-fpm.conf

cd /home/matt/src
wget "http://download.suhosin.org/suhosin-$SUHOSIN_VER.tar.gz"
tar -xzvf "suhosin-$SUHOSIN_VER.tar.gz"
cd "suhosin-$SUHOSIN_VER"
phpize
./configure
make -j4
checkinstall make install

echo "" >> /usr/local/lib/php/php.ini
echo ";Our mods" >> /usr/local/lib/php/php.ini
echo "" >> /usr/local/lib/php/php.ini
echo "extension = suhosin.so" >> /usr/local/lib/php/php.ini
echo "extension = imagick.so" >> /usr/local/lib/php/php.ini
echo "extension = apc.so" >> /usr/local/lib/php/php.ini 
echo "apc.enabled = 1" >> /usr/local/lib/php/php.ini 
echo "apc.shm_size=128M" >> /usr/local/lib/php/php.ini #make this bigger on a bigger server.
echo "error_reporting = E_ALL | E_STRICT" >> /usr/local/lib/php/php.ini
echo "log_errors_max_len = 0" >> /usr/local/lib/php/php.ini
echo "error_log = /var/log/php/error_log" >> /usr/local/lib/php/php.ini
echo "session.gc_maxlifetime = 28800" >> /usr/local/lib/php/php.ini
echo "upload_max_filesize = 1024M" >> /usr/local/lib/php/php.ini
echo "max_file_uploads = 200" >> /usr/local/lib/php/php.ini
echo "upload_tmp_dir = /tmp" >> /usr/local/lib/php/php.ini
echo "post_max_size = 1025M" >> /usr/local/lib/php/php.ini
echo "expose_php = Off" >> /usr/local/lib/php/php.ini
echo "date.timezone = America/New_York" >> /usr/local/lib/php/php.ini

/bin/cp "/home/matt/src/php-$PHP_VER/sapi/fpm/init.d.php-fpm" /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
sed -i 's/php_fpm_PID=${prefix}\/var\/run\/php-fpm.pid/php_fpm_PID=\/var\/run\/php-fpm.pid/' /etc/init.d/php-fpm
if [ $OS = "Ubuntu" ]; then
	update-rc.d php-fpm defaults
else
	chkconfig --level 35 php-fpm on
fi

mkdir -p /var/log/php

if [ $OS = "Ubuntu" ]; then
	chown -R nobody:nogroup /var/log/php
else
	chown -R nobody:nobody /var/log/php
fi

chmod -R aou+w /var/log/php
mkdir -p /usr/local/var/run
mkdir -p /usr/local/var/log

service php-fpm start

#TODO:
#For igbinary:
#sudo apt-get install git-core
#cd /opt
#git clone http://github.com/phadej/igbinary.git
#cd igbinary
#git checkout 1.0.2
#phpize
#./configure CFLAGS="-O2 -g" --enable-igbinary
#time make
#sudo checkinstall --backup=no -D make install
#Change #4 to '1'

#For memcached:
#sudo apt-get install libevent-dev automake
#cd /opt
#git clone http://github.com/memcached/memcached.git
#cd memcached
#git checkout 1.4.5
#./autogen.sh
#./configure
#time make
#sudo checkinstall --backup=no -D make install
    #Change 4 to 1
    #Change 10 ('Requires') to ''

#For libmemcached:
#cd /opt
#wget http://launchpad.net/libmemcached/1.0/0.42/+download/libmemcached-0.42.tar.gz
#tar xzvf libmemcache...
#cd libmemcached
#./configure
#make dist
#sudo checkinstall --backup=no -D make install

#For php-memcached:
#cd /opt
#git clone http://github.com/andreiz/php-memcached.git
#cd php-memcached
#phpize
#./configure --enable-memcached-igbinary
#time make
#sudo checkinstall --backup=no -D make install
    #Change Name and Provides to php-memcached!, Version to the commit shorthand (7 chars, c1133281 last time you did it)
