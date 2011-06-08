#!/usr/bin/env bash

#TODO: Figure out restart functionality, like so:
#http://forums.techguy.org/linux-unix/981948-restart-parameter.html

#set -o nounset #Quit on unset variables.
set -o errexit # Quit on error.
set -o xtrace # Print the statement before you execute it.

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

trap "python $WD/emailer.py failed \${LINENO};" ERR

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

		#TODO: Figure out why installing Python from source is breaking Rhythmbox.
		--python)
			export python="yes"
			;;
		--d8)
			export d8="yes"
			;;
		--clang)
			export clang="yes"
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
	useradd -s /bin/bash -G wheel -m -p `python -c 'import crypt; print crypt.crypt("changeme", "$6$salt$6$");'` matt
fi

system_update

mkdir -p /home/matt/src

. $WD/ruby-deps.sh

cp $WD/ruby.sh /opt
chmod 755 /opt/ruby.sh
if [ $variant == "server" ]; then
	. /opt/ruby.sh
else
	su -l matt -c "/opt/ruby.sh"
fi

#. $WD/checkinstall.sh
. $WD/git.sh
#. $WD/sqlite.sh
. $WD/python.sh
. $WD/vim.sh

if [ $variant == "workstation" ]; then
	. $WD/desktop.sh
fi

curl http://betterthangrep.com/ack-standalone > /usr/local/bin/ack
chmod 0755 /usr/local/bin/ack

#If it's a workstation, I've already cloned a writable copy of this repo since ssh-add isn't completely automatable.
if [ $variant == "server" ]; then
	cd /home/matt
	git clone https://github.com/mblair/dotfiles
fi

. $WD/dotfiles.sh

chown -R matt:matt /home/matt/src
chown -R matt:matt /home/matt/dotfiles

echo "Done!"
python $WD/emailer.py succeeded
