#!/usr/bin/env bash

set -e
set -x
shopt -s expand_aliases

TMPDIR=/home/matt/src
#MARIADB_VER=5.2.6
MARIADB_VER=5.3.0-beta
MARIADB_PASSWORD=changeme

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

if [ $OS = "Ubuntu" ]; then
	apt-get install -y bison libreadline-dev
else
	yum install -y bison readline-devel automake libtool
fi

cd /home/matt/src
wget http://ftp.osuosl.org/pub/mariadb/mariadb-$MARIADB_VER/kvm-tarbake-jaunty-x86/mariadb-$MARIADB_VER.tar.gz
tar xzvf mariadb-$MARIADB_VER.tar.gz
cd mariadb-$MARIADB_VER

if [ $ARCH -eq 64 ]; then
	BUILD/compile-pentium64-max
else
	BUILD/compile-pentium-max
fi

checkinstall --fstrans=no make install

if [ $OS = "Ubuntu" ]
then
	adduser --system --no-create-home --disabled-login --disabled-password --group mysql
else
	groupadd -r mysql
	adduser -M -r -g mysql mysql
fi 

cd /usr/local/mysql
chown -R mysql .
chgrp -R mysql .
bin/mysql_install_db --user=mysql #mysql uses scripts/
chown -R root .
chown -R mysql var/ #instead of mysql's data/
. /root/.bash_profile
echo "PATH=$PATH:/usr/local/mysql/bin" >> /root/.bash_profile
echo "PATH=$PATH:/usr/local/mysql/bin" >> /home/matt/.bash_profile
. /root/.bash_profile
bin/mysqld_safe --user=mysql &
sleep 10 # Give it time to start.
echo "DELETE FROM mysql.user WHERE User='';" | mysql -u root
echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" | mysql -u root
#rm -f data/test/.empty
echo "DROP DATABASE test;" | mysql -u root
echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'" | mysql -u root
echo "UPDATE mysql.user SET Password=PASSWORD('$MARIADB_PASSWORD') WHERE User='root';" | mysql -u root

#mysql uses support-files/ for these.
cp share/mysql/mysql.server /etc/init.d/mysqld
cp share/mysql/my-medium.cnf /etc/my.cnf
sed -i 's/basedir=$/basedir=\/usr\/local\/mysql/g' /etc/init.d/mysqld
sed -i 's/datadir=$/datadir=\/usr\/local\/mysql\/var/g' /etc/init.d/mysqld

if [ $OS = "Ubuntu" ]; then
	update-rc.d mysqld defaults
else
	chkconfig mysqld on
fi

if [ $OS = "Ubuntu" ]; then
	apt-get -y install bzr
else
	yum install -y bzr
fi

cd /home/matt/src
bzr branch lp:mysql-udf-regexp
cd mysql-udf-regexp/regexp
./configure --with-mysql-src=/home/matt/src/mariadb-$MARIADB_VER --libdir=/usr/local/mysql/lib/mysql/plugin
make -j4
checkinstall --pkgname="mysql-udf-regexp" --pkgversion="1.0" make install

echo 'CREATE FUNCTION regexp_like RETURNS INTEGER SONAME "regexp.so";' | mysql -u root
echo 'CREATE FUNCTION regexp_substr RETURNS STRING SONAME "regexp.so";' | mysql -u root
echo 'CREATE FUNCTION regexp_instr RETURNS INTEGER SONAME "regexp.so";' | mysql -u root
echo 'CREATE FUNCTION regexp_replace RETURNS STRING SONAME "regexp.so";' | mysql -u root

#TODO: Figure out why this hangs.
echo "FLUSH PRIVILEGES;" | mysql -u root

echo "Done!"
