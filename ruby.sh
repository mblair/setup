#!/usr/bin/env bash
set -e
set -x

curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
./rvm-installer --version latest

if [ $variant == "server" ]; then
	echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" # load rvm function' >> /root/.bash_profile
	echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm" # load rvm function' >> /home/matt/.bash_profile
	source /root/.bash_profile
	echo 'install: --no-rdoc --no-ri' >> /root/.gemrc
	echo 'update: --no-rdoc --no-ri' >> /root/.gemrc
else
	. "$HOME/.rvm/scripts/rvm"
fi

echo 'install: --no-rdoc --no-ri' >> /home/matt/.gemrc
echo 'update: --no-rdoc --no-ri' >> /home/matt/.gemrc
echo "--drb" >> ~/.rspec
echo "--colour" >> ~/.rspec

rvm install 1.9.2
rvm use 1.9.2 --default

#rvm install kiji

#Because these rock.
#gem install bundler
#gem install showoff
#gem install rails
#gem install rocco
#gem install capistrano
gem install fpm
