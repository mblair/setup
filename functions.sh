#!/usr/bin/env bash

usage() {
	echo "Usage: $0 [options] || --help"
	echo
	echo "	--help		- Display this usage text."
}

arch() {
	if [ `uname -m` = "x86_64" ] #One can get i386 or i686, so I test the other.
	then
		ARCH=64
	else
		ARCH=32
	fi
}

os() {
	if [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
	then
		OS="Ubuntu"
	else
		OS="other" # Fedora may come later. Maybe.
	fi
}

system_update() {
	if [ $OS = "Ubuntu" ]; then
		apt-get update
		apt-get -y dist-upgrade
		apt-get install -y bash-completion locate ntp htop build-essential debian-archive-keyring pigz gettext dpkg-dev nload curl apt-file sloccount tree irssi libbz2-dev
		apt-get update #because of debian-archive-keyring
		apt-file update	

		echo "America/New_York" > /etc/timezone # /usr/share/zoneinfo
		dpkg-reconfigure -f noninteractive tzdata
	fi
}
