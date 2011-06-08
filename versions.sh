#!/usr/bin/env bash

EPEL_RELEASE=5-4 #http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F
RPMFORGE_VER=0.5.2-2 #http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
GIT_VER=1.7.5.4 #http://git-scm.com/
#SQLITE_VER=3070603 #http://www.sqlite.org/download.html
PYTHON_VER=2.7.1 #http://python.org/download/
PYTHON_SHORT_VER="`echo $PYTHON_VER | cut -f1 -d"."`.`echo $PYTHON_VER | cut -f2 -d"."`"
PYTHON3_VER=3.2 #http://python.org/download/
PYTHON3_SHORT_VER="`echo $PYTHON3_VER | cut -f1 -d"."`.`echo $PYTHON3_VER | cut -f2 -d"."`"
HG_VER=1.8.4 #http://mercurial.selenic.com/downloads/
VIM_VER=7.3 #http://www.vim.org/download.php
PERCONA_DEFAULT_VER=5.5
PERCONA_MYSQL_51_VER=5.1.56 #http://www.percona.com/downloads/
PERCONA_MYSQL_51_SHORT_VER=5.1
PERCONA_51_VER=12.7 #http://www.percona.com/downloads/
PERCONA_MYSQL_55_VER=5.5.11 #http://www.percona.com/downloads/
PERCONA_MYSQL_55_SHORT_VER=5.5
PERCONA_55_VER=20.2 #http://www.percona.com/downloads/
#POSTGRES_VER=9.0.4 #http://www.postgresql.org/
POSTGRES_VER=9.1beta1 #http://www.postgresql.org/developer/beta
LLVM_VER=2.9 #http://llvm.org/releases/
NGINX_VER=1.0.4 #http://nginx.org/en/download.html

IRC_PASS=changeme
