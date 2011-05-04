curl -s https://rvm.beginrescueend.com/install/rvm -o rvm-installer
chmod +x rvm-installer
./rvm-installer --version latest
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.' >> ~/.bash_profile
. "$HOME/.rvm/scripts/rvm"

echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
echo 'update: --no-rdoc --no-ri' >> ~/.gemrc
echo "--drb" >> ~/.rspec
echo "--colour" >> ~/.rspec

rvm install ree
rvm install 1.9.2-head
rvm use 1.9.2-head --default

#Because these rock.
gem install bundler
gem install showoff
