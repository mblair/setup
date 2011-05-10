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
make -j4
checkinstall --pkgname="matt-vim" --pkgversion="$VIM_VER.$PATCH_LEVEL" make install
