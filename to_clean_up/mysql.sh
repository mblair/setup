#!/usr/bin/env bash

set -e
set -x

MYSQL_VER=5.5.11
MYSQL_PASSWORD=changeme

if [[ `cat /etc/*-release | awk '{print $1}' -` = "CentOS" ]]; then
	OS="CentOS"
elif [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
then
	OS="Ubuntu"
else
	OS="neither" # Debian is on the roadmap.
fi

if [ $OS = "Ubuntu" ]; then
	apt-get install -y bison libreadline-dev cmake
else
	yum install -y bison readline-devel cmake
fi

cd /opt
wget http://mysql.mirrors.pair.com/Downloads/MySQL-5.5/mysql-$MYSQL_VER.tar.gz 
tar xzvf mysql-$MYSQL_VER.tar.gz
cd mysql-$MYSQL_VER
mkdir bld
cd bld
cmake .. -DENABLE_ASSEMBLER=1 -DWITH_INNODB_PLUGIN=1 -DWITH_MYISAM=1 -DWITHOUT_PLUGIN_INNOBASE=1 -DWITH_FAST_MUTEXES=1 -DWITH_EXTRA_CHARSETS=all -DENABLE_THREAD_SAFE_CLIENT=1 -DENABLE_LOCAL_INFILE=1 -DENABLE_SHARED=1 -DWITHOUT_READLINE=1 -DWITHOUT_DEBUG=1 -DWITH_ZLIB=system -DWITH_COMMENT:STRING="Built By Matty B"
time make -j4
checkinstall make install





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
scripts/mysql_install_db --user=mysql
chown -R root .
chown -R mysql data
. ~/.bash_profile
echo "PATH=$PATH:/usr/local/mysql/bin" >> ~/.bash_profile
. ~/.bash_profile
bin/mysqld_safe --user=mysql &
sleep 10 # Give it time to start.
echo "DELETE FROM mysql.user WHERE User='';" | mysql -u root
echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" | mysql -u root
rm -f data/test/.empty
echo "DROP DATABASE test;" | mysql -u root
echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'" | mysql -u root
echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
cp support-files/mysql.server /etc/init.d/mysqld
cp support-files/my-medium.cnf /etc/my.cnf
sed -i 's/basedir=.$/basedir=\/usr\/local\/mysql/g' /etc/init.d/mysqld

if [ $OS = "Ubuntu" ]; then
	update-rc.d mysqld defaults
else
	chkconfig mysqld on
fi
