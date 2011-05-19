#!/usr/bin/env bash

EPEL_RELEASE=5-4
GIT_VER=1.7.5.1
SQLITE_VER=3070603
PYTHON_VER=2.7.1
PYTHON_SHORT_VER="`echo $PYTHON_VER | cut -f1 -d"."`.`echo $PYTHON_VER | cut -f2 -d"."`"
PYTHON3_VER=3.2
PYTHON3_SHORT_VER="`echo $PYTHON3_VER | cut -f1 -d"."`.`echo $PYTHON3_VER | cut -f2 -d"."`"
PIP_VER=1.0 #You may not need this anymore.
HG_VER=1.8.3
VIM_VER=7.3
PERCONA_DEFAULT_VER=5.5
PERCONA_MYSQL_51_VER=5.1.56
PERCONA_MYSQL_51_SHORT_VER=5.1
PERCONA_51_VER=12.7
PERCONA_MYSQL_55_VER=5.5.11
PERCONA_MYSQL_55_SHORT_VER=5.5
PERCONA_55_VER=20.2
POSTGRES_VER=9.0.4
LLVM_VER=2.9
NGINX_VER=1.0.2 #http://nginx.org/en/download.html

IRC_PASS=changeme
