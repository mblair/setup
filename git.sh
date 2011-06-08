if [ $OS = "CentOS" ]; then
	yum install -y expat-devel gettext-devel curl-devel openssl-devel zlib-devel
	yum -yq remove git
else
	apt-get install -y libexpat1-dev gettext libcurl4-gnutls-dev libssl-dev zlib1g-dev

	apt-get -y purge git-core git #`git-core` is now `git`. Uninstall both since I'm pretty sure git-core exists in Lucid.
fi

cd /home/matt/src
wget http://kernel.org/pub/software/scm/git/git-$GIT_VER.tar.bz2
tar xjvf git-$GIT_VER.tar.bz2
cd git-$GIT_VER
mkdir /tmp/installdir
make -j5 all DESTDIR=/tmp/installdir prefix=/usr/local
make install DESTDIR=/tmp/installdir prefix=/usr/local
fpm -s dir -t deb -n git -v "1:$GIT_VER" -C /tmp/installdir
dpkg -i git_1\:"$GIT_VER"_amd64.deb
cp /home/matt/src/git-$GIT_VER/contrib/completion/git-completion.bash /home/matt/.git-completion.bash

cd /home/matt/src
wget http://kernel.org/pub/software/scm/git/git-manpages-$GIT_VER.tar.bz2
tar -x -C /usr/local/share/man/ -vf git-manpages-$GIT_VER.tar.bz2

hash -r #to clear out the old git (/usr/bin/git), which no longer exists.
git clone git://github.com/visionmedia/git-extras.git #git-summary, other goodies
cd git-extras
make install PREFIX=./build/usr/local
fpm -s dir -t deb -n git-extras -C ./build .
dpkg -i git-extras*.deb
