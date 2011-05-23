#!/usr/bin/env bash

echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

set -e

variant="server"

die() {
	echo >&2 "$@"
	exit 1
}

adduser() {
	if [ $variant == "server" ]; then
		if [ "foo" = "bar" ]; then
			bogus_cmd
		fi
		other_bogus_cmd
	fi
}

adduser || die "Couldn't add user."
