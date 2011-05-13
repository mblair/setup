# Setup Scripts

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS for servers at work, and I've been using Ubuntu for the last two and a half years at home.

## USAGE

### To use these on an Ubuntu server, run the following:

* `apt-get update && apt-get -y install byobu`
* `byobu`
* `curl -Lsf https://github.com/mblair/setup/tarball/master | tar xz`
* `cd mblair-setup-[TAB][CR]`
* Change the password and recipient email address in emailer.py.
* `time ./setup.sh --server 2>&1 | tee ~/output`

You'll get an email when the script finishes, error or not.

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
* Change the password in `emailer.py`
* `time ./setup.sh --workstation 2>&1 | tee /home/matt/output`
* Set chromium-browser settings: sync, download location, fonts, enable global menu support in about:flags.
* `ssh-copy-id shortname` for all of my servers.
* Remove the first entries from `~/.ssh/known_hosts` since they were added before HashKnownHosts was turned off.
* Build thumbnails.
* Restart.
* Install Virtualbox Extension Pack, guest OSs & Guest Additions.
* Configure Rhythmbox.
* Edit Launcher entries.
* Configure Deluge (download location, ports, bandwidth)
* Hit 'Install Drivers' to get the restricted drivers tray icon to go away on your laptop (boo Broadcom).

Running `setup.sh` takes about 65 minutes on my laptop (Dell XPS M1330, Core 2 Duo T5450 1.66GHz w/ 32KB/2MB L1/L2, 2GB PC2-5300 RAM) connected via wireless at home.

## TODO

* Review everything and remove cruft.
* Refactor so you can run arbitrary setup scripts and use versions/functions/etc, not just the reformatting ones.
* Fix these: `grep -Pinr "^[\t]*if[^=]*=[^=]" *`, making them all use double equals.
* Use long options in scripts for readability, or comment heavily.
* Prompt for emailer.py settings using `read -s shellvar`
* Have `emailer.py` mention time taken.
* Remove `aptitude` refs since I no longer hold packages.
* Reformatting stats for the desktop, laptop at SBU via Ethernet.
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

## LICENSE

New BSD. See `LICENSE`.
