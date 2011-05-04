#!/usr/bin/env bash
#miminal, versions, functions, checkinstall, git, vim

#TODO: Get this all working with Debian, Fedora, Arch & Gentoo.
#TODO: Just put ". ~/.bashrc" in ~/.bash_profile for Ubuntu, remove ". ~/.bash_profile" from CentOS's .bashrc (<- ?)

# http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046
# Used to print timing information & current line number. Coupled with set -x, you get:
# 1291311776.120680354 (5) + echo 0
# where 5 is the line number and `echo 0` is the statement on that line. 
#TODO: Figure out why this line is problematic.
#PS4='$(date "+%s.%N ($LINENO) + ")'

shopt -s expand_aliases # so `python setup.py install` within this script uses the new python. saves me from having to specify the full path to the binary every time.

#Save the location of this file, so I can still call the ancillary scripts (git.sh, vim.sh, etc) after `cd`ing around the FS.
#I'm sourcing the other scripts instead of using a subshell, so this is important.
WD=`pwd`

#This is for servers with small /tmp mounts. gcc uses this value.
TMPDIR=/home/matt/src

#TODO: Put these in /opt so the user `matt` can access them.
. versions.sh
. functions.sh

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

while [[ $# -gt 0 ]]; do

	token="$1" ; shift
	
	case "$token" in
		--server)
			export variant="server"
			;;
		--workstation)
			export variant="workstation"
			;;
		--help)
			usage
			exit 0
			;;
		*)
			echo "Unrecognized option: $token"
			usage
			exit 1
			;;
	esac
done

arch
os

if [ $variant == "server" ]; then
	if [ $OS = "Ubuntu" ]; then
		groupadd -r wheel
	fi
	echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
	useradd -G wheel -m -p `python -c 'import crypt; print crypt.crypt("changeme", "$6$salt$6$");'` matt
fi

set -e # Quit on error.
set -x # Print the statement before you execute it.

system_update

mkdir -p /home/matt/src

. $WD/checkinstall.sh
. $WD/git.sh
. $WD/sqlite.sh
. $WD/python.sh
. $WD/vim.sh
#. $WD/percona.sh

curl http://betterthangrep.com/ack-standalone > /usr/local/bin/ack
chmod 0755 /usr/local/bin/ack

chown -R matt:matt /home/matt/src

#desktop.sh
#matt.sh #TODO: Run as `matt`.
#ruby-deps.sh
#ruby.sh #TODO: Run as `matt`.

echo "Done!"
