cd /home/matt/src
wget https://github.com/rg3/youtube-dl/raw/master/youtube-dl
chmod +x youtube-dl
ln -s /home/matt/src/youtube-dl /usr/local/bin/

#http://mmcgrana.github.com/2010/07/install-java-ubuntu.html

echo "deb http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list
echo "deb-src http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list
cat << EOD | debconf-set-selections
sun-java5-jdk shared/accepted-sun-dlj-v1-1 select true
sun-java5-jre shared/accepted-sun-dlj-v1-1 select true
sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true
sun-java6-jre shared/accepted-sun-dlj-v1-1 select true
EOD

dpkg --set-selections << EOS
sun-java6-jdk install
EOS

apt-get update
apt-get install -y sun-java6-jdk -y
update-java-alternatives -s java-6-sun --jre

#http://www.panticz.de/install-acrobat-reader
cat << EOD | debconf-set-selections
acroread acroread/default-viewer boolean true
EOD

#http://www.panticz.de/install_mx
cat << EOD | debconfi-set-selections
postfix postfix/mailname string mx
postfix postfix/main_mailer_type select Internet Site
EOD

#http://ubuntuforums.org/showpost.php?p=4907079&postcount=1 (x264/libvpx/ffmpeg/qt-faststart)
apt-get remove ffmpeg x264 libx264-dev
apt-get install yasm texi2html libfaac-dev libjack-jackd2-dev libmp3lame-dev \
	libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev \
	libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev
cd /home/matt/src
git clone git://git.videolan.org/x264
cd x264
./configure
make -j3
checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
    awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
    --fstrans=no --default

apt-get remove libvpx-dev
cd /home/matt/src
git clone git://review.webmproject.org/libvpx
cd libvpx
./configure
make -j3
checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default

cd /home/matt/src
git clone git://git.videolan.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc \
    --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
    --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis \
    --enable-libx264 --enable-libxvid --enable-x11grab --enable-libvpx
make -j3
checkinstall --pkgname=ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default
hash x264 ffmpeg ffplay ffprobe

cd /home/matt/src/ffmpeg
make tools/qt-faststart
checkinstall --pkgname=qt-faststart --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default install -D -m755 tools/qt-faststart \
    /usr/local/bin/qt-faststart

cd /home/matt/src/x264
make distclean
./configure
make -j4
sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
    awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
    --fstrans=no --default

echo "deb http://download.virtualbox.org/virtualbox/debian natty contrib" >> /etc/apt/sources.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -

aptitude update
aptitude install -y miredo subversion apt-listchanges unrar rar cfv \
	xclip openssh-server mp3splt gtkpod chmsee konversation extace \
	acroread cheese fbreader pitivi gimp gimp-data-extras \
	gstreamer0.10-plugins-ugly vlc gstreamer0.10-ffmpeg gstreamer0.10-plugins-bad \
	gstreamer0.10-plugins-ugly-multiverse skype flashplugin-installer \
	gstreamer0.10-plugins-bad-multiverse virtualbox-4.0 sun-java6-plugin \
	sun-java6-jdk electricsheep libnotify-bin ncurses-term ttf-inconsolata \
	ttf-droid pandoc texlive-latex-recommended texlive-xetex texlive-latex-extra \
	ubuntu-restricted-extras deluge-torrent pidgin k3b
add-apt-repository ppa:chromium-daily/dev
add-apt-repository ppa:jonls/redshift-ppa

#TODO: Check for newer versions, since the ones in the Natty repos are just as new.
#http://dev.deluge-torrent.org/wiki/ChangeLog
#add-apt-repository ppa:deluge-team/ppa
#add-apt-repository ppa:pidgin-developers/ppa

add-apt-repository ppa:pmcenery/ppa
aptitude update
aptitude -y upgrade #for libimobiledevice1 and friends
aptitude -y install chromium-browser chromium-browser-inspector redshift

mv /home/matt/.bashrc /home/matt/.bashrc.default

#aptitude -y install libreadline-dev scons
#ln -s /usr/lib32/libstdc++.so.6 /usr/lib32/libstdc++.so
#cd /home/matt/src
#svn co http://v8.googlecode.com/svn/trunk v8
#cd v8
#scons arch=x64 console=readline d8
#cd /usr/local/bin
#ln -s /home/matt/src/v8/d8 d8

#LLVM_SHORT_VER=29
#cd /home/matt/src
#svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_$LLVM_SHORT_VER/final llvm
#cd llvm/tools
#svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_$LLVM_SHORT_VER/final clang
#cd ..
#./configure --enable-optimized
#make -j3
#. /home/matt/.bash_profile #Or else the previous PATH modifications won't carry over.
#echo "PATH=/home/matt/src/llvm/Release/bin:$PATH" >> /home/matt/.bash_profile

#TODO: Turn off indexing service after you run Konversation the first time.
mkdir -p /home/matt/.kde/share/apps/konversation/
ln -s /home/matt/Dropbox/konversationui.rc /home/matt/.kde/share/apps/konversation/
mkdir -p /home/matt/.kde/share/config/
#rm -f /home/matt/.kde/share/config/konversationrc
ln -s /home/matt/Dropbox/konversationrc /home/matt/.kde/share/config/

#Get Redshift to run on startup.

#Download the Chrome deb:
#http://www.google.com/chrome/intl/en/eula_dev.html?dl=unstable_amd64_deb
#Extract it, get libpdf.so out of opt/google/chrome
#Copy that to /usr/lib/chromium-browser
#Set chromium-browser up to sync, change download location to Desktop, enable global menu support in about:flags
#Create a chromium-browser bash alias to add --password-store=basic

#cd /home/matt/src
#svn co http://rbeq.googlecode.com/svn/trunk/ rbeq
#cd rbeq
#cp -R rhythmbox /home/matt/.gnome2
#cd /home/matt/.local/share
#rm -rf rhythmbox
#ln -s /home/matt/Dropbox/rhythmbox/ rhythmbox

ln -s ~/Drobox/ssh_config ~/.ssh/config
chmod 600 ~/.ssh/config
#Edit /etc/ssh/ssh_config, set HashKnownHosts No so that IP addy autocompletion works for ssh
#`ssh-copy-id` blah for all of your servers

#Build thumbnails.

#Install Virtualbox Extension Pack, guest OSs & Guest Additions.
#Install code.google.com/p/feedindicator
mkdir -p /home/matt/.config/feedindicator
ln -s ~/Dropbox/feedindicator/feeds.cfg ~/.config/feedindicator/

mkdir /home/matt/Deluge_Incoming
#ln -s ~/Dropbox/deluge/[blah] ~/.config/deluge/

mkdir -p /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/accounts.xml /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/logs/ /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/prefs.xml /home/matt/.purple/

#Edit /usr/share/applications/chromium-browser.desktop
#Exec=/usr/bin/chromium-browser %U
#Exec=/usr/bin/chromium-browser --password-store=basic %U

#gconftool-2 --set /apps/metacity/general/button_layout --type string ":"
#gconftool --set /apps/compiz-1/general/screen0/options/hsize --type=int 3
#gconftool --set /apps/compiz-1/general/screen0/options/vsize --type=int 2
