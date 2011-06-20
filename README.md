# Setup

This is the tool I use to set up my Ubuntu workstations at home.

## USAGE

### Here's how I test using a Linode:

* `apt-get update && apt-get -y install git byobu`
* `byobu`
* `ssh-keygen -q -b 4096 -t rsa -N [passphrase] -f /root/.ssh/id_rsa`
* Add the SSH key to GitHub.
* `git clone git@github.com:mblair/setup.git`
* `git clone git@github.com:mblair/personal.git`
* `cd setup`
* Change the password in `emailer.py`
* `time ./setup.sh 2>&1 | tee ~/output`

### Here's how I set up a workstation:
* Enter wireless password.
* `sudo apt-get update && sudo apt-get -y install xclip git byobu`
* `ssh-keygen -q -b 4096 -t rsa -f /home/matt/.ssh/id_rsa`
* Add the SSH key to GitHub.
* `git clone git@github.com:mblair/setup.git`
* `git clone git@github.com:mblair/personal.git`
* `byobu`
* `sudo su`
* `cd setup`
* Change the password in `emailer.py`
* `time ./setup.sh 2>&1 | tee /home/matt/output`
* Open Firefox, download and install Dropbox.
* Set chromium-browser settings: sync, download location, fonts, enable global menu support in about:flags.
* Configure gnome-terminal & Nautilus.
* Configure system settings.
* `ssh-copy-id shortname` for all of my servers.
* Remove the first entries (GitHub) from `~/.ssh/known_hosts` since they were added before HashKnownHosts was turned off.
* Build thumbnails.
* Install Virtualbox Extension Pack, guest OSs & Guest Additions.
* Configure Rhythmbox (may no longer be necessary).
* Configure Deluge (download location, ports, bandwidth) (may no longer be necessary)
* Hit 'Install Drivers' to get the restricted drivers tray icon to go away on your laptop (boo Broadcom).
* Install [this](https://addons.mozilla.org/en-US/firefox/addon/video-downloadhelper/)
* Restart.

## TODO

* Set up an APT mirror at home, like [this](http://odzangba.wordpress.com/2007/12/24/use-apt-mirror-to-create-your-own-ubuntu-mirror/), so `apt-get dist-upgrade` doesn't take so long.
* Create a Debian archive for git/python/vim/pidgin/etc, like [Debra](http://rcrowley.github.com/debra/), using [these](http://scotbofh.wordpress.com/2011/04/26/creating-your-own-signed-apt-repository-and-debian-packages/) [two](http://www.debian-administration.org/article/286/Setting_up_your_own_APT_repository_with_upload_support) resources, so you only have to build packages once per release.
* Easy updates based on `versions.sh` (upgrade/downgrade/outdated). Upgrade uninstalls the old packages, grab the new source, compile, build, install. Downgrade does the same, needs an explicit version. Outdated compares installed versions with `versions.sh`. Upgrade without a package upgrades all.

* Automate the screen bootstrapping, possibly with techniques from [here](http://www.linuxjournal.com/article/6340?page=0,1).
* An automatic installer, like oh-my-zsh and RVM. Have it bootstrap Git via a Gist or a standalone script in this repo, then clone this repo (via https, since you can't add your public key without your API key being available somehow) and get going.
* Figure out restart functionality, like [so](http://forums.techguy.org/linux-unix/981948-restart-parameter.html).
* Figure out why installing Python from source is breaking Rhythmbox.
* Possibly switch to [Clementine](https://launchpad.net/~me-davidsansome/+archive/clementine).
* Put GnuPG instructions in here.

#### No longer important:
* Refactor so you can run arbitrary setup scripts and still use the main versions.sh/functions.sh. So 'movein' (all of what setup currently performs) would become a recipe of sorts, demoted to the same level as 'gitweb' or 'nginx'.
* Make the name of the added user configurable.
* Nicer directory structure (packages go in a separate folder)
* Use [Roundup](http://itsbonus.heroku.com/p/2010-11-01-roundup). This looks awesome.
* Organize stuff into functions, not just files. Then you can source everything, and run `func || die` so your error handler knows where shit hit the fan.
* Man pages using [ronn](http://rtomayko.github.com/ronn/) once you've got some useful flags that require explanation.
* Makefile like [this](https://github.com/visionmedia/git-extras/blob/master/Makefile) or a Rakefile like [this](https://github.com/cloudfoundry/vcap/blob/master/Rakefile). Probably a Makefile, since you won't have to jump through hoops just to get it to run.
* Source documentation with [Shocco](http://rtomayko.github.com/shocco/). Expand flags in the source so you have less documentation to write (just explain short ones that don't have a long form).
* [Bash completion](http://www.debian-administration.org/articles/316), based on [Homebrew's](https://github.com/mxcl/homebrew/blob/master/Library/Contributions/brew_bash_completion.sh).
* Nested READMEs. I didn't realize this was possible.
* Check out [Aruba](https://github.com/cucumber/aruba/blob/master/features/interactive.feature) for testing. [Here's another example](https://github.com/rspec/rspec-core/tree/master/features/command_line). And [here](http://skillsmatter.com/podcast/ajax-ria/lessons-learned-bdd-ing-a-command-line-utility-gem) is a video. And a [blog post](http://www.themodestrubyist.com/2010/04/22/aruba---cucumber-goodness-for-the-command-line/).
* Test changes with [vagrant](http://vagrantup.com/docs/getting-started/index.html) before committing.
* Set up a [Jenkins](http://jenkins-ci.org/) instance to test changes locally via Vagrant before you push to GitHub, as well as any pull requests before merging them.
* Have `emailer.py` mention time taken and attach a log of the output. Remove the `time` from the `setup.sh` invocation.
* Nicer error handling (see `test.sh`), have `emailer.py` mention what section failed.
* Fix these: `grep -Pinr "^[\t]*if[^=]*=[^=]" *`, making them all use double equals. Bash accepts singles but they look scary.
* Easy way to upgrade/uninstall setup itself (like RVM's `get head` and `implode`, or `brew update`)
* Make the timezone configurable.
* File where you can declare what's installed, not just 'movein' or 'nginx'; how about both?
* See what gstreamer packages are installed by the Ubuntu desktop installer's non-free option, and see if removing the others from `desktop.sh` will affect `totem-video-thumbnailer`, since you use VLC anyway.
* Make sure you mention that this needs to be run as root, and that it updates your system (and therefore should be run on a fresh box).
* Better SSH security like [so](http://articles.slicehost.com/2010/4/30/ubuntu-lucid-setup-part-1)
* Nice installation messages like [railsready](https://github.com/joshfng/railsready/blob/master/railsready.sh) and [RVM](https://github.com/wayneeseguin/rvm/blob/master/scripts/functions/installer).
* Figure out a Vim version string that doesn't cause apt to want to update it. Probably `2:blah`.
* [Versions](http://semver.org/) with a VERSION file.
* [Changelog](https://github.com/visionmedia/git-extras/blob/master/bin/git-changelog), or something like `git commit -v` that shows you a diff since the last tag and lets you write a changelog. I'm not sure commit messages make the most sense for a changelog.
* A `HACKING` file that talks about internals, once they're ready to be talked about.
* Add a [progress bar](http://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-bash-script/238094#238094).
* Create a Yum repository, possibly. [Here](http://narrabilis.com/mybook/repo)'s a tutorial, I think.
* Make this work with Arch, but only customization (dotfiles, whatever else) since Arch [stays current](http://www.archlinux.org/packages/extra/i686/ruby/) and is source-based. Plus FPM doesn't do Arch.
* Gentoo support. Maybe.
* Figure out how to profile this, possibly [like so](http://stackoverflow.com/questions/4336035/performance-profiling-tools-for-shell-scripts/4338046#4338046).

## LICENSE

MIT. See `LICENSE` for details.
