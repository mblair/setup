#!/usr/bin/env bash
set -e
set -x

if grep 'lucid' /etc/lsb-release 1>/dev/null; then
		apt-get -y install git-core
else
		apt-get -y install git
fi

curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
./rvm-installer --version latest
. "$HOME/.rvm/scripts/rvm"

echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
echo 'update: --no-rdoc --no-ri' >> ~/.gemrc
echo "--drb" >> ~/.rspec
echo "--colour" >> ~/.rspec

rvm install 1.9.2-head
rvm use 1.9.2-head --default

#Because these rock.
gem install bundler
gem install showoff
gem install rails
gem install rocco
gem install capistrano
gem install fpm

if [ $ruby18 == "yes" ]; then
        rvm install ree
fi