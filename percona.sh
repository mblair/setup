#!/usr/bin/env bash

set -e
set -x

if [ $PERCONA_DEFAULT_VER == "5.1" ]; then
	cd /home/matt/src
	wget http://www.percona.com/redir/downloads/Percona-Server-$PERCONA_MYSQL_51_SHORT_VER/Percona-Server-$PERCONA_MYSQL_51_VER-$PERCONA_51_VER/source/Percona-Server-$PERCONA_MYSQL_51_VER.tar.gz
	tar xzvf Percona-Server-$PERCONA_MYSQL_51_VER.tar.gz
	cd Percona-Server-$PERCONA_MYSQL_51_VER
	CFLAGS="-O3" CXX=gcc CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" ./configure --prefix=/usr/local/mysql --enable-assembler --with-mysqld-ldflags=-all-static --with-plugins=innodb_plugin,myisam --without-plugin-innobase --with-fast-mutexes --with-extra-charsets=all --enable-thread-safe-client --enable-local-infile --enable-shared --without-readline --without-debug --with-zlib-dir= #Mine, works on 10.04.
	make -j4
	checkinstall make install
else
	if [ $OS = "Ubuntu" ]; then
		apt-get install -y bison libreadline-dev cmake
	else
		yum install -y bison readline-devel cmake
	fi

	cd /home/matt/src
	wget http://www.percona.com/redir/downloads/Percona-Server-$PERCONA_MYSQL_55_SHORT_VER/Percona-Server-$PERCONA_MYSQL_55_VER-$PERCONA_55_VER/source/Percona-Server-$PERCONA_MYSQL_55_VER-$PERCONA_55_VER.tar.gz
	tar xzvf Percona-Server-$PERCONA_MYSQL_55_VER-$PERCONA_55_VER.tar.gz
	cd Percona-Server-$PERCONA_MYSQL_55_VER-$PERCONA_55_VER
	mkdir bld
	cd bld
	cmake .. -DENABLE_ASSEMBLER=1 -DWITH_INNODB_PLUGIN=1 -DWITH_MYISAM=1 -DWITHOUT_PLUGIN_INNOBASE=1 -DWITH_FAST_MUTEXES=1 -DWITH_EXTRA_CHARSETS=all -DENABLE_THREAD_SAFE_CLIENT=1 -DENABLE_LOCAL_INFILE=1 -DENABLE_SHARED=1 -DWITHOUT_READLINE=1 -DWITHOUT_DEBUG=1 -DWITH_ZLIB=system -DWITH_COMMENT:STRING="Built By Matty B"
	make -j4
	checkinstall make install
fi
