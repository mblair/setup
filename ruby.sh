#!/usr/bin/env bash
set -e
set -x

curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
./rvm-installer --version latest

echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> /home/matt/.bash_profile
. "$HOME/.rvm/scripts/rvm"

echo "export rvm_pretty_print_flag=1" > /home/matt/.rvmrc
echo 'install: --no-rdoc --no-ri' > /home/matt/.gemrc
echo 'update: --no-rdoc --no-ri' >> /home/matt/.gemrc
echo "--drb" > /home/matt/.rspec
echo "--colour" >> /home/matt/.rspec

rvm install 1.9.2 --docs #RVM doesn't install ri documentation by default.
rvm use 1.9.2 --default

#rvm install kiji

#Because these rock.
gem install bundler showoff capistrano rocco rails fpm redis sinatra json mail unicorn shotgun haml rack-parser rspec-rails cucumber sqlite3 jekyll rdiscount

cd /home/matt/
git clone git://gitorious.org/learnrubythehardway/learnrubythehardway
cd learnrubythehardway
jekyll --no-auto --pygments
