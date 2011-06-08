#!/usr/bin/env bash

set -e
set -x

if [ $OS = "Ubuntu" ]; then
	apt-get install -y bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev ncurses-dev
else
	yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 iconv-devel
fi

#The RVM installer needs Git.
if [ $OS = "Ubuntu" ]; then
	if grep 'lucid' /etc/lsb-release 1>/dev/null; then
			apt-get -y install git-core
	else
			apt-get -y install git
	fi
fi
