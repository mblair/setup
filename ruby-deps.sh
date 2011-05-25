#!/usr/bin/env bash

set -e
set -x

apt-get install -y bison libxml2-dev libxslt1-dev autoconf libreadline-dev libssl-dev

#The RVM installer needs Git.
if grep 'lucid' /etc/lsb-release 1>/dev/null; then
		apt-get -y install git-core
else
		apt-get -y install git
fi