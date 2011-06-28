apt-get install -y libexpat1-dev gettext libcurl4-gnutls-dev libssl-dev zlib1g-dev

apt-get -y purge git-core git

cd /home/matt/src
wget http://www.alpaca-farm.lkams.kernel.org/pub/software/scm/git/git-$GIT_VER.tar.bz2
tar xjvf git-$GIT_VER.tar.bz2
cd git-$GIT_VER
mkdir /tmp/gitdir
make -j3 all DESTDIR=/tmp/gitdir prefix=/usr/local
make install DESTDIR=/tmp/gitdir prefix=/usr/local
chown -R matt:matt /tmp/gitdir /home/matt/src/git-$GIT_VER
su -l matt -c "cd /home/matt/src/git-$GIT_VER && fpm -s dir -t deb -n git -v "1:$GIT_VER" -C /tmp/gitdir"

if [ $ARCH -eq 64 ]; then
	dpkg -i git_1\:"$GIT_VER"_amd64.deb
else
	dpkg -i git_1\:"$GIT_VER"_i386.deb
fi

cp /home/matt/src/git-$GIT_VER/contrib/completion/git-completion.bash /home/matt/.git-completion.bash

cd /home/matt/src
wget http://www.alpaca-farm.lkams.kernel.org/pub/software/scm/git/git-manpages-$GIT_VER.tar.bz2
tar -x -C /usr/local/share/man/ -vf git-manpages-$GIT_VER.tar.bz2

hash -r #to clear out the old git (/usr/bin/git), which no longer exists.
git clone git://github.com/visionmedia/git-extras.git #git-summary, other goodies
cd git-extras
make install PREFIX=./build/usr/local
GIT_EXTRAS_VER=`grep 'VERSION=' bin/git-extras | cut -f2 -d '"'`
chown -R matt:matt /home/matt/src/git-extras
su -l matt -c "cd /home/matt/src/git-extras && fpm -s dir -t deb -n git-extras -v "1:$GIT_EXTRAS_VER" -C ./build ."

if [ $ARCH -eq 64 ]; then
	dpkg -i git-extras_1\:"$GIT_EXTRAS_VER"_amd64.deb
else
	dpkg -i git-extras_1\:"$GIT_EXTRAS_VER"_i386.deb
fi

#For `git create`, `git init -g`
curl http://defunkt.io/hub/standalone -sLo /usr/local/bin/hub
chmod 755 /usr/local/bin/hub
