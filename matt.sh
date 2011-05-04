#!/usr/bin/env bash

set -e
set -x

git config --global user.name "Matt Blair"
git config --global user.email me@matthewblair.net
git config --global alias.co checkout
git config --global alias.st "status --ignore-submodules=untracked"
git config --global alias.br branch
git config --global alias.last 'log -1 HEAD'
git config --global merge.tool vimdiff
git config --global core.excludesfile /home/matt/.gitignore_global
git config --global core.editor "vim -f"

# See if you can find coloring for `add -p`'s prompt line.
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global color.status.changed yellow
git config --global color.status.added green
git config --global color.status.untracked red

git config --global  core.pager "less"
echo '.*.sw[a-z]' > /home/matt/.gitignore_global

cd /home/matt/dotfiles
git submodule update --init
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

#TODO: Symlink .bashrc also.
cd /home/matt
ln -s /home/matt/dotfiles/vim .vim
ln -s /home/matt/dotfiles/vimrc .vimrc
mkdir /home/matt/dotfiles/vim/plugin
mkdir /home/matt/dotfiles/vim/doc
mkdir /home/matt/dotfiles/vim/undodir
cp /home/matt/src/vim/runtime/macros/matchit.vim /home/matt/dotfiles/vim/plugin/
cp /home/matt/src/vim/runtime/macros/matchit.txt /home/matt/dotfiles/vim/doc/

# Get rid of min/max/close buttons completely.
# Alt-F10 toggles maximization
# Quit depends on the app:
# Could be Ctrl-Q, Ctrl-W, or Ctrl-Shift-Q (Chrome)
#gconftool-2 --set /apps/metacity/general/button_layout --type string ":"

gconftool --set /apps/compiz-1/general/screen0/options/hsize --type=int 3
gconftool --set /apps/compiz-1/general/screen0/options/vsize --type=int 2

mkdir /home/matt/.irssi
ln -s /home/matt/dotfiles/irssi_config /home/matt/.irssi/config
sed -i "/identify/ c\\t\tautosendcmd = '/msg nickserv identify $IRC_PASS';" /home/matt/.irssi/config
