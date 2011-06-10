# Setup Scripts

These are the scripts I use to set up Linux servers at [work](http://www.grossmaninteractive.com) and my workstations at home. We use CentOS and Ubuntu for servers at work, and I've been using Ubuntu for the last two and a half years at home.

## USAGE

### To use these on an Ubuntu server, run the following:

* `apt-get update && apt-get -y install byobu`
* `byobu`
* `curl -Lsf https://github.com/mblair/setup/tarball/master | tar xz`
* `cd mblair-setup-[TAB][CR]`
* Change the sender/recipient email addresses and password in emailer.py.
* `time ./setup.sh --server 2>&1 | tee ~/output`

You'll get an email when the script finishes, error or not.

This has been tested on Linodes running Ubuntu 11.04 x86\_64 and 10.04 i386.

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

## TODO

#### Soon:
* Refactor so you can run arbitrary setup scripts and still use the main versions.sh/functions.sh. So 'movein' (all of what setup currently performs) would become a recipe of sorts, demoted to the same level as 'gitweb' or 'nginx'.
* Make the name of the added user configurable.
* Automate the screen bootstrapping, possibly with techniques from [here](http://www.linuxjournal.com/article/6340?page=0,1).
* An automatic installer, like oh-my-zsh and RVM. Have it bootstrap Git via a Gist or a standalone script in this repo, then clone this repo and get going.
* Nicer directory structure (packages go in a separate folder)
* Organize stuff into functions, not just files. Then you can source everything, and run `func || die` so your error handler knows where shit hit the fan.
* Man pages using [ronn](http://rtomayko.github.com/ronn/) once you've got some useful flags that require explanation.
* Makefile like [this](https://github.com/visionmedia/git-extras/blob/master/Makefile) or a Rakefile like [this](https://github.com/cloudfoundry/vcap/blob/master/Rakefile). Probably a Makefile, since you won't have to jump through hoops just to get it to run.
* Source documentation with [Shocco](http://rtomayko.github.com/shocco/). Expand flags in the source so you have less documentation to write (just explain short ones that don't have a long form).
* Easy updates based on `versions.sh` (update/upgrade/downgrade/outdated).
* [Bash completion](http://www.debian-administration.org/articles/316), based on [Homebrew's](https://github.com/mxcl/homebrew/blob/master/Library/Contributions/brew_bash_completion.sh).
* Nested READMEs. I didn't realize this was possible.
* Check out [Aruba](https://github.com/cucumber/aruba/blob/master/features/interactive.feature) for testing. [Here's another example](https://github.com/rspec/rspec-core/tree/master/features/command_line). And [here](http://skillsmatter.com/podcast/ajax-ria/lessons-learned-bdd-ing-a-command-line-utility-gem) is a video. And a [blog post](http://www.themodestrubyist.com/2010/04/22/aruba---cucumber-goodness-for-the-command-line/).
* Test changes with [vagrant](http://vagrantup.com/docs/getting-started/index.html) before pushing to GitHub.
* Set up a [Jenkins](http://jenkins-ci.org/) instance to test changes locally via Vagrant before you push to GitHub, as well as any pull requests before merging them.
* Have `emailer.py` mention time taken and attach a log of the output. Remove the `time` from the `setup.sh` invocation.
* Nicer error handling (see `test.sh`), have `emailer.py` mention what section failed.
* Fix these: `grep -Pinr "^[\t]*if[^=]*=[^=]" *`, making them all use double equals. Bash accepts singles but they look scary.
* Complete CentOS support.
* Prompt for `emailer.py` settings (to, from, from's password), possibly using `read -s shellvar`. Keep it Gmail/Google Apps only, let's not get crazy.
* Easy way to upgrade/uninstall setup itself (like RVM's `get head` and `implode`, or `brew update`)
* Split the workstation stuff into a different repo that relies on this one (keep/remove `--workstation`/`--server`, respectively).
* More friendly README like [RVM's](https://github.com/wayneeseguin/rvm/blob/master/README).
* Make sure RVM's installation still works on workstations.
* Reformatting stats for all machines now that you're using fpm.
* Make the timezone configurable.
* Review everything (this README especially).

#### Later:
* Figure out why installing Python from source is breaking Rhythmbox.
* Switch to [Clementine](https://launchpad.net/~me-davidsansome/+archive/clementine).
* See what gstreamer packages are installed by the Ubuntu desktop installer's non-free option, and see if removing the others from `desktop.sh` will affect `totem-video-thumbnailer`, since you use VLC anyway.
* Put GnuPG instructions in here for workstations.
* Make sure you mention that this needs to be run as root, and that it updates your system (and therefore should be run on a fresh box).
* Better SSH security like [so](http://articles.slicehost.com/2010/4/30/ubuntu-lucid-setup-part-1)
* Nice installation messages like [railsready](https://github.com/joshfng/railsready/blob/master/railsready.sh) and [RVM](https://github.com/wayneeseguin/rvm/blob/master/scripts/functions/installer).
* Figure out a Vim version string that doesn't cause apt to want to update it. Probably `2:blah`.
* [Versions](http://semver.org/) with a VERSION file.
* [Changelog](https://github.com/visionmedia/git-extras/blob/master/bin/git-changelog), or something like `git commit -v` that shows you a diff since the last tag and lets you write a changelog. I'm not sure commit messages make the most sense for a changelog.
* A `HACKING` file that talks about internals, once they're ready to be talked about.
* Add a [progress bar](http://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-bash-script/238094#238094).
* Create a Debian archive, like [Debra](http://rcrowley.github.com/debra/), using [these](http://scotbofh.wordpress.com/2011/04/26/creating-your-own-signed-apt-repository-and-debian-packages/) [two](http://www.debian-administration.org/article/286/Setting_up_your_own_APT_repository_with_upload_support) resources.
* Create a Yum repository, possibly. [Here](http://narrabilis.com/mybook/repo)'s a tutorial, I think.
* Debian Sid support.
* Fedora support for the workstation stuff. Maybe.
* Sexy website. So necessary.
* Make this work with Arch, but only customization (dotfiles, whatever else) since Arch [stays current](http://www.archlinux.org/packages/extra/i686/ruby/) and is source-based. Plus FPM doesn't do Arch.
* Gentoo support. Maybe.
* Figure out how to profile this, possibly [like so](http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046).
* Make this a full-blown packaging system, since that hasn't been done before ;-)

## LICENSE

MIT. See `LICENSE` for details.
