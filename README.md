# Setup Scripts

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS and Ubuntu for servers at work, and I've been using Ubuntu for the last two and a half years at home.

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
* Install [this](https://addons.mozilla.org/en-US/firefox/addon/video-downloadhelper/)

Running `setup.sh` takes about 65 minutes on my laptop (Dell XPS M1330, Core 2 Duo T5450 1.66GHz w/ 32KB/2MB L1/L2, 2GB PC2-5300 RAM) connected via wireless at home.

## TODO

#### Soon:
* System-wide Ruby for servers, personal Ruby for workstations.
* Refactor so you can run arbitrary setup scripts and use versions/functions/etc, not just the reformatting ones.
* Ensure every variable has a default value, uncomment nounset.
* Put GnuPG instructions in here.
* Make sure you mention that this needs to be run as root, and that it updates your system.
* Nicer error handling (see test.sh)
* Nice installation messages like [railsready](https://github.com/joshfng/railsready/blob/master/railsready.sh) and [RVM](https://github.com/wayneeseguin/rvm/blob/master/scripts/functions/installer).
* Start using fpm instead of checkinstall.
* Have `emailer.py` mention time taken.
* Fix these: `grep -Pinr "^[\t]*if[^=]*=[^=]" *`, making them all use double equals.
* Figure out a Vim version string that doesn't cause apt to want to update it.
* Nicer README like [RVM's](https://github.com/wayneeseguin/rvm/blob/master/README).
* [Versions](http://semver.org/) with a VERSION file.
* [Changelog](https://github.com/visionmedia/git-extras/blob/master/bin/git-changelog), or something like `git commit -v` that shows you a diff since the last tag and lets you write a changelog. I'm not sure commit messages make the most sense for a changelog.
* A `HACKING` file that talks about internals.
* An automatic installer, like oh-my-zsh and RVM.
* Nicer directory structure (packages go in a separate folder)
* Man pages using [ronn](http://rtomayko.github.com/ronn/)
* Makefile like [this](https://github.com/visionmedia/git-extras/blob/master/Makefile) or a Rakefile like [this](https://github.com/cloudfoundry/vcap/blob/master/Rakefile).
* Call Vim "vim" instead of "matt-vim"
* Remove `aptitude` refs since I no longer need to hold Git and Vim.
* Review everything and remove cruft (configurable username, etc.)
* Add a [progress bar](http://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-bash-script/238094#238094).
* Easy updates based on `versions.sh` (update/upgrade/outdated).
* [Bash completion](http://www.debian-administration.org/articles/316), based on [Homebrew's](https://github.com/mxcl/homebrew/blob/master/Library/Contributions/brew_bash_completion.sh).
* `grep -r 'TODO' *` from the root of the source tree for more.
* Check out [Aruba](https://github.com/cucumber/aruba/blob/master/features/interactive.feature) for testing.
* Create a Debian archive once you hit 1.0, like [Debra](http://rcrowley.github.com/debra/), using [these](http://scotbofh.wordpress.com/2011/04/26/creating-your-own-signed-apt-repository-and-debian-packages/) [two](http://www.debian-administration.org/article/286/Setting_up_your_own_APT_repository_with_upload_support) resources.

#### Later:
* Debian support.
* Fedora support.
* Sexy website. So necessary.
* Set up Jenkins to test changes before you push to GitHub, as well as pull requests before merging them.
* Easy way to upgrade/uninstall setup itself (like RVM's `get head` and `implode`)
* Use long options in scripts for readability (they're not being run manually, so who cares?)
* Prompt for emailer.py settings (to, from, password), possibly using `read -s shellvar`. Keep it Gmail/Google Apps only, let's not get crazy.
* Reformatting stats for my desktop, servers at work.
* Make this work with Arch, but only customization (dotfiles, whatever else) since Arch [stays current](http://www.archlinux.org/packages/extra/i686/ruby/) and is source-based. Plus FPM doesn't do Arch.
* Complete CentOS support, only if CentOS isn't dead before I get to this.
* Gentoo support. Maybe.
* Figure out how to profile this, possibly [like so](http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046).
* Make this a full-blown packaging system, since that hasn't been done before ;-)

## LICENSE

MIT. See `LICENSE` for details.
