#!/usr/bin/env bash
#TODO: Get the rpmforge versions out of here.

usage() {
	echo "Usage: $0 <variant> || --help"
	echo
	echo "	--help		- Display this usage text."
	echo
	echo "The two variants are:"
	echo
	echo "	--server	- Don't install GUI libs/apps."
	echo "	--workstation	- Install GUI libs and apps."
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
	if [[ `cat /etc/*-release | awk '{print $1}' -` = "CentOS" ]]; then
		OS="CentOS"
	elif [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
	then
		OS="Ubuntu"
	else
		OS="neither" # Others are on the roadmap.
	fi
}

system_update() {
	if [ $OS = "CentOS" ]; then
		rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-$EPEL_RELEASE.noarch.rpm
		cd /home/matt/src
		if [ $ARCH -eq 64 ]; then
			wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.1-1.el5.rf.x86_64.rpm
			rpm -Uvh rpmforge-release-0.5.1-1.el5.rf.x86_64.rpm
		else
			wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.1-1.el5.rf.i386.rpm
			rpm -Uvh rpmforge-release-0.5.1-1.el5.rf.i386.rpm
		fi
		yum -yq upgrade
		yum install -y bash-completion mlocate ntp htop make gcc gcc-c++ patch pigz git gettext rpm-build bzip2-devel
		/bin/cp /usr/share/zoneinfo/America/New_York /etc/localtime # because cp = cp -i on CentOS, and we can't have that.
	else
		apt-get update
		apt-get -y dist-upgrade
		apt-get install -y bash-completion locate ntp htop build-essential debian-archive-keyring pigz gettext dpkg-dev nload curl apt-file sloccount aptitude tree irssi libbz2-dev
                if grep 'lucid' /etc/lsb-release 1>/dev/null
                then
                        apt-get -y install git-core
                else
                        apt-get -y install git
                fi

		apt-file update	
		apt-get update

		#TODO: Make this configurable.
		echo "America/New_York" > /etc/timezone # /usr/share/zoneinfo
		dpkg-reconfigure -f noninteractive tzdata
	fi
}
