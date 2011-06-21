apt-get remove -y vim-runtime

apt-get -y install libncurses5-dev exuberant-ctags libgtk2.0-dev libxt-dev libgnomeui-dev

cd /home/matt/src
hg clone https://vim.googlecode.com/hg/ vim
cd vim

if [ $python = "yes" ]; then
	PATH="/home/matt/src/python$PYTHON_VER/bin:$PATH" #Hack to make Vim use a juicy Python, only if I installed it.
fi

./configure --enable-pythoninterp --enable-multibyte --with-features=huge --enable-cscope --enable-gui=gnome2

PATCH_LEVEL=`grep -A3 'static int included_patches' src/version.c | tr -dc '[:digit:]'`
mkdir /tmp/vimdir
make -j3 DESTDIR=/tmp/vimdir
make install DESTDIR=/tmp/vimdir
chown -R matt:matt /tmp/vimdir /home/matt/src/vim
su -l matt -c "cd /home/matt/src/vim && fpm -s dir -t deb -n vim -v 2:"$VIM_VER.$PATCH_LEVEL" -C /tmp/vimdir"

if [ $ARCH -eq 64 ]; then
	dpkg -i vim_2\:"$VIM_VER.$PATCH_LEVEL"_amd64.deb
else
	dpkg -i vim_2\:"$VIM_VER.$PATCH_LEVEL"_i386.deb
fi
