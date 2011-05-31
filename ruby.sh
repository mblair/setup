#!/usr/bin/env bash
set -e
set -x

curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
./rvm-installer --version latest
. "$HOME/.rvm/scripts/rvm"

echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
echo 'update: --no-rdoc --no-ri' >> ~/.gemrc
echo "--drb" >> ~/.rspec
echo "--colour" >> ~/.rspec

rvm install 1.9.2
rvm use 1.9.2 --default

rvm install kiji

#Because these rock.
gem install bundler
gem install showoff
gem install rails
gem install rocco
gem install capistrano
gem install fpm