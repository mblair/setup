if [ $OS = "CentOS" ]; then
	yum install -y expat-devel gettext-devel curl-devel openssl-devel zlib-devel
	yum -yq remove git
else
	#libcurl4-gnutls-dev installs zlib1g-dev, so don't worry about it for nginx/ruby/mysql/etc
	aptitude install -y libexpat1-dev gettext libcurl4-gnutls-dev libssl-dev 

	aptitude -y purge git-core git #`git-core` is now `git`. Uninstall both since I'm pretty sure git-core exists in Lucid.
fi

cd /home/matt/src
wget http://kernel.org/pub/software/scm/git/git-$GIT_VER.tar.bz2
tar xjvf git-$GIT_VER.tar.bz2
cd git-$GIT_VER
make prefix=/usr/local -j4 all
checkinstall --pkgname="matt-git" --pkgversion="$GIT_VER" --fstrans=no make prefix=/usr/local install
cp /home/matt/src/git-$GIT_VER/contrib/completion/git-completion.bash /home/matt/.git-completion.bash

cd /home/matt/src
wget http://kernel.org/pub/software/scm/git/git-manpages-$GIT_VER.tar.bz2
tar -x -C /usr/local/share/man/ -vf git-manpages-$GIT_VER.tar.bz2

hash -r #to clear out the old git (/usr/bin/git), which no longer exists.
git clone git://github.com/visionmedia/git-extras.git #git-summary, other goodies
cd git-extras
checkinstall --pkgname="git-extras" --provides="git-extras" --pkgversion="1-$(git rev-list HEAD -n1)" make install
