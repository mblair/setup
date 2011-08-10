#!/usr/bin/env bash

set -o errexit # Quit on error.
set -o xtrace # Print the statement before you execute it.

shopt -s expand_aliases # so `python setup.py install` within this script uses the new python. saves me from having to specify the full path to the binary every time.

#Save the location of this file, so I can still call the ancillary scripts (git.sh, vim.sh, etc) after `cd`ing around the FS.
#I'm sourcing the other scripts instead of using a subshell, so this is important.
export WD=`pwd`

trap "python $WD/emailer.py failed \${LINENO};" ERR

. versions.sh
. functions.sh

while [[ $# -gt 0 ]]; do

	token="$1" ; shift

	case "$token" in
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

#Default values.
echo "${python="no"}"
echo "${d8="yes"}"
echo "${clang="no"}"

arch
os

system_update

if ! grep 'matt' /etc/passwd 1>/dev/null; then
	groupadd -r wheel
	echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
	useradd -s /bin/bash -G wheel -m -p `python -c 'import crypt; print crypt.crypt("changeme", "$6$salt$6$");'` matt
fi

mkdir -p /home/matt/src
chown matt:matt /home/matt/src

. $WD/ruby-deps.sh

cp $WD/ruby.sh /opt
chmod 755 /opt/ruby.sh
su -l matt -c "/opt/ruby.sh"

. $WD/git.sh
. $WD/python.sh
. $WD/vim.sh
. $WD/workstation.sh

curl http://betterthangrep.com/ack-standalone > /usr/local/bin/ack
chmod 0755 /usr/local/bin/ack

cd /home/matt
git clone https://github.com/mblair/dotfiles

. $WD/dotfiles.sh

chown -R matt:matt /home/matt/src
chown -R matt:matt /home/matt/dotfiles
chown matt:matt /home/matt/.bash_profile
chown matt:matt /home/matt/Desktop/LearnPythonTheHardWay.pdf

python $WD/emailer.py succeeded
echo "Done!"
