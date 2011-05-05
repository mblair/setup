cd /home/matt/dotfiles
ln -s /home/matt/dotfiles/gitconfig /home/matt/.gitconfig
git submodule update --init
echo '.*.sw[a-z]' > /home/matt/.gitignore_global

#To add:
#git submodule add git://github.com/user/repo.git vim/bundle/repo
#Add `ignore = dirty` to .gitmodules if you get complaints.
#To remove:
	#Remove the line from .gitmodules
	#Remove the entry from .git/config <- never had to do this
	#git rm --cached vim/bundle/repo <- not sure about this bad boy either
#Every now and then:
#git submodule foreach git pull origin master
#Then `git add vim/bundle/blah` for the updated ones and commit the updates.

cd vim
mkdir autoload
cd autoload
#TODO: Use curl instead, this shit is bananas.
wget https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim --no-check-certificate # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=409938

cd /home/matt
ln -s /home/matt/dotfiles/vim .vim
ln -s /home/matt/dotfiles/vimrc .vimrc
mkdir /home/matt/dotfiles/vim/plugin
mkdir /home/matt/dotfiles/vim/doc
mkdir /home/matt/dotfiles/vim/undodir
cp /home/matt/src/vim/runtime/macros/matchit.vim /home/matt/dotfiles/vim/plugin/
cp /home/matt/src/vim/runtime/macros/matchit.txt /home/matt/dotfiles/vim/doc/

mkdir /home/matt/.irssi
ln -s /home/matt/dotfiles/irssi_config /home/matt/.irssi/config
sed -i "/identify/ c\\t\tautosendcmd = '/msg nickserv identify $IRC_PASS';" /home/matt/.irssi/config

mv /home/matt/.bashrc /home/matt/.bashrc.default
ln -s /home/matt/dotfiles/bashrc /home/matt/.bashrc
