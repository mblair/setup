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

rvm install 1.9.2 --docs #Need this for Octopress :-/
rvm install 1.9.3 --docs #RVM doesn't install ri documentation by default.
rvm use 1.9.3 --default
gem update --system

#Because these rock.
gem install bundler showoff capistrano rocco rails fpm redis sinatra json mail unicorn shotgun haml rack-parser rspec-rails cucumber sqlite3 jekyll rdiscount em-hiredis em-websocket sass eventmachine-tail strace_me trollop raindrops kgio foreman bcrypt_ruby

cd /home/matt/src
git clone git://gitorious.org/learnrubythehardway/learnrubythehardway
cd learnrubythehardway
jekyll --no-auto --pygments
cp -R _site/* /var/www/

cd /home/matt
git clone git@github.com:mblair/mblair.github.com
cd mblair.github.com
rvm use 1.9.2
git remote add octopress git://github.com/imathis/octopress.git
gem install bundler
git checkout source
bundle install
git clone git@github.com:mblair/mblair.github.com _deploy
rake config_deploy[master]
mkdir public # Octopress' sitemap_generator.rb bails without this.
rake generate

# Interesting Ruby projects to read:
cd /home/matt/ruby_repos
git clone https://github.com/auxesis/visage
git clone https://github.com/bf4/vimeo_downloader/
git clone https://github.com/dainelvera/Vimeo-Video-Downloader
git clone https://github.com/danielsdeleo/critical
git clone https://github.com/danlucraft/retwis-rb
git clone https://github.com/defunkt/cijoe
git clone https://github.com/etsy/deployinator
git clone https://github.com/fetep/pencil
git clone https://github.com/flogic/whiskey_disk
git clone https://github.com/integrity/integrity
git clone https://github.com/jamesgolick/degrade
git clone https://github.com/jamesgolick/rigger
git clone https://github.com/jamesgolick/rollout
git clone https://github.com/johnewart/ruby-metrics
git clone https://github.com/jordansissel/fpm
git clone https://github.com/lenary/ginatra
git clone https://github.com/lusis/Noah
git clone https://github.com/mojombo/grit
git clone https://github.com/reinh/statsd
git clone https://github.com/sinatra/sinatra-book
git clone https://github.com/sinatra/sinatra-book-contrib
git clone https://github.com/sstephenson/rbenv
git clone https://github.com/sstephenson/ruby-build
