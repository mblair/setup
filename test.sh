#!/usr/bin/env bash

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
