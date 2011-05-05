# Setup Scripts

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS for servers at work, and I've been using Ubuntu for the last two and a half years at home.

## USAGE

### To use these on an Ubuntu server, run the following:

* `apt-get update && apt-get -y install byobu`
* `byobu`
* `curl -Lsf https://github.com/mblair/setup/tarball/master | tar xz`
* `cd mblair-setup-[TAB][CR]`
* Change the password and recipient email address in emailer.py.
* `time ./setup.sh --server 2>&1 | tee ~/output; python emailer.py`

This has been tested on Linodes running Ubuntu 11.04 x86\_64 and 10.04 i386. It takes about 35-40 minutes on a Linode 512; [checkinstall](http://www.asic-linux.com.mx/~izto/checkinstall/) takes up too much of that time for my tastes. I may switch to rcrowley's [debra](http://rcrowley.github.com/debra/) if it's faster and just as good in a non-interactive environment.

### Here are my notes for setting up a workstation:

* Enter wireless password.
* Open Firefox, download and install Dropbox.
* Configure gnome-terminal & Nautilus.
* Configure system settings.
* `ssh-keygen -t rsa`
* `sudo apt-get update && sudo apt-get -y install xclip git byobu`
* `byobu`
* `cat .ssh/id_rsa.pub | xclip -selection clipboard`
* Swap your GitHub, Bitbucket keys.
* `git clone git@github.com:mblair/setup.git`
* `git clone git@github.com:mblair/dotfiles.git`
* `sudo su`
* `cd setup`
* Change the password and recipient email address in emailer.py.
* `time ./setup.sh --workstation 2>&1 | tee /home/matt/output; python emailer.py`
* Set chromium-browser settings: sync, download location, fonts, enable global menu support in about:flags.
* `ssh-copy-id shortname` for all of my servers.
* Build thumbnails.
* Restart.
* Install Virtualbox Extension Pack, guest OSs & Guest Additions.

## TODO

* Check out debra since checkinstall is slow.
* Complete CentOS support.
* Debian support.
* Fedora support.
* Gentoo support.
* Arch support.
* Figure out how to profile this, possibly [like so](http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046).
* One-step updates based on `versions.sh`
* Make this a full-blown packaging system, since that hasn't been done before ;-)
* `grep -r 'TODO' *` from the root of the tree for more.
