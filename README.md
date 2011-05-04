Setup Scripts
=============

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS for servers at work, and I've been using Ubuntu for the last two and a half years at home.

USAGE
=====

To use these on an Ubuntu server, run the following:

* `apt-get update && apt-get -y install byobu`
* `byobu`
* `curl -Lsf https://github.com/mblair/setup/tarball/master | tar xz`
* `cd mblair-setup-[TAB][CR]`
* `time ./setup.sh --server 2>&1 | tee ~/output`

This has been tested on a fresh Linode running Ubuntu 11.04 x86_64. It takes about 40 minutes on a Linode 512; [checkinstall](http://www.asic-linux.com.mx/~izto/checkinstall/) takes up too much of that time for my tastes. I may switch to rcrowley's [debra](http://rcrowley.github.com/debra/) if it's faster and just as good in a non-interactive environment.

TODO
====

* Check out debra since checkinstall is slow.
* Complete CentOS support.
* Debian support.
* Fedora support.
* Gentoo support.
* Arch support.
* Figure out how to profile this, possibly [like so](http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046).
* One-step updates based on `versions.sh`
* Make this a full-blown packaging system, since that hasn't been done before ;-)