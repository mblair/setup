Setup Scripts
=============

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS for servers at work, and I've been using Ubuntu for the last two years at home. I'm probably switching to Fedora, so those OSs will receive the most love at first.

TODO
====

* Fedora support.
* Gentoo support.
* Debian support.
* Arch support.

To use these on a fresh Ubuntu server, run the following:

* `apt-get update && apt-get -y install byobu`
* `byobu`
* `curl -Lsf https://github.com/mblair/setup_scripts/tarball/master | tar xz`
* `cd mblair-setup_scripts-[TAB][CR]`
* `time ./setup.sh --server 2>&1 | tee ~/output`
