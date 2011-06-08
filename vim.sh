if [ $OS = "CentOS" ]; then
	yum -yq remove vim-common
else
	apt-get remove -y vim-runtime
fi

if [ $OS = "CentOS" ]; then
	yum -yq install ncurses-devel
else
	apt-get -y install libncurses5-dev exuberant-ctags
fi

if [ $variant == "workstation" ]; then
	apt-get install -y libgtk2.0-dev libxt-dev libgnomeui-dev
fi

cd /home/matt/src
hg clone https://vim.googlecode.com/hg/ vim
cd vim

if [ $python = "yes" ]; then
	PATH="/home/matt/src/python$PYTHON_VER/bin:$PATH" #Hack to make Vim use a juicy Python, only if I installed it.
fi

configure='./configure --enable-pythoninterp --enable-multibyte --with-features=huge --enable-cscope'
if [ $variant == "workstation" ]; then
	configure+=' --enable-gui=gnome2'
fi
eval $configure

PATCH_LEVEL=`grep -A3 'static int included_patches' src/version.c | tr -dc '[:digit:]'`
mkdir /tmp/vimdir
make -j5 DESTDIR=/tmp/vimdir
make install DESTDIR=/tmp/vimdir
fpm -s dir -t deb -n vim -v "$VIM_VER.$PATCH_LEVEL" -C /tmp/vimdir

if [ $ARCH -eq 64 ]; then
	dpkg -i vim_"$VIM_VER.$PATCH_LEVEL"_amd64.deb
else
	dpkg -i vim_"$VIM_VER.$PATCH_LEVEL"_i386.deb
fi
