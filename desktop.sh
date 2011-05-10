echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

cd /home/matt/src
curl https://github.com/rg3/youtube-dl/raw/master/youtube-dl > youtube-dl
chmod +x youtube-dl
ln -s /home/matt/src/youtube-dl /usr/local/bin/

#http://mmcgrana.github.com/2010/07/install-java-ubuntu.html
echo "deb http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list
echo "deb-src http://archive.canonical.com/ubuntu natty partner" >> /etc/apt/sources.list

wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/natty.list
apt-get update
apt-get -y --allow-unauthenticated install medibuntu-keyring
apt-get update

apt-get -y install libdvdcss2

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
apt-get install -y sun-java6-jdk
update-java-alternatives -s java-6-sun --jre

#http://www.panticz.de/install-acrobat-reader
echo "acroread acroread/default-viewer boolean true" | debconf-set-selections

#http://www.panticz.de/install_mx
cat << EOD | debconf-set-selections
postfix postfix/mailname string mx
postfix postfix/main_mailer_type select Internet Site
EOD

#http://ubuntuforums.org/showpost.php?p=4907079&postcount=1 (x264/libvpx/ffmpeg/qt-faststart)
apt-get -y remove ffmpeg x264 libx264-dev
apt-get -y install yasm texi2html libfaac-dev libjack-jackd2-dev libmp3lame-dev \
	libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev \
	libva-dev libvdpau-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev
cd /home/matt/src
git clone git://git.videolan.org/x264
cd x264
./configure
make -j3
checkinstall --pkgname=matt-x264 --pkgversion="3:$(./version.sh | \
    awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
    --fstrans=no --default

apt-get -y remove libvpx-dev
cd /home/matt/src
git clone git://review.webmproject.org/libvpx
cd libvpx
./configure
make -j3
checkinstall --pkgname=matt-libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default

cd /home/matt/src
git clone git://git.videolan.org/ffmpeg
cd ffmpeg
./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc \
    --enable-libfaac --enable-libmp3lame --enable-libopencore-amrnb \
    --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis \
    --enable-libx264 --enable-libxvid --enable-x11grab --enable-libvpx
make -j3
checkinstall --pkgname=matt-ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default
hash x264 ffmpeg ffplay ffprobe

cd /home/matt/src/ffmpeg
make tools/qt-faststart
checkinstall --pkgname=matt-qt-faststart --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
    --deldoc=yes --fstrans=no --default install -D -m755 tools/qt-faststart \
    /usr/local/bin/qt-faststart

cd /home/matt/src/x264
make distclean
./configure
make -j3
checkinstall --pkgname=matt-x264 --pkgversion="3:$(./version.sh | \
    awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
    --fstrans=no --default

echo "deb http://download.virtualbox.org/virtualbox/debian natty contrib" >> /etc/apt/sources.list
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -

apt-get update
apt-get install -y miredo subversion unrar rar cfv \
	openssh-server mp3splt gtkpod chmsee konversation extace \
	acroread cheese fbreader gimp gimp-data-extras \
	gstreamer0.10-plugins-ugly-multiverse skype  \
	gstreamer0.10-plugins-bad-multiverse virtualbox-4.0 sun-java6-plugin \
	electricsheep libnotify-bin ncurses-term ttf-inconsolata \
	ttf-droid pandoc ubuntu-restricted-extras deluge-torrent pidgin k3b rhythmbox vlc

#TODO: Some other time, too big.
#apt-get install -y texlive-latex-recommended texlive-xetex texlive-latex-extra

#TODO: Check for newer versions, since the ones in the Natty repos are just as new.
#http://dev.deluge-torrent.org/wiki/ChangeLog
#add-apt-repository ppa:deluge-team/ppa
#http://developer.pidgin.im/wiki/ChangeLog
#add-apt-repository ppa:pidgin-developers/ppa

#TODO: Check to see if Natty pkgs show up here.
#add-apt-repository ppa:jonls/redshift-ppa

add-apt-repository ppa:chromium-daily/dev
add-apt-repository ppa:pmcenery/ppa
apt-get update
apt-get -y upgrade #for libimobiledevice1 and friends
apt-get -y install chromium-browser chromium-browser-inspector redshift

if [ $d8 == "yes" ]; then
	apt-get -y install libreadline-dev scons
	ln -s /usr/lib32/libstdc++.so.6 /usr/lib32/libstdc++.so
	cd /home/matt/src
	svn co http://v8.googlecode.com/svn/trunk v8
	cd v8
	scons arch=x64 console=readline d8
	cd /usr/local/bin
	ln -s /home/matt/src/v8/d8 d8
fi

if [ $clang == "yes" ]; then
	cd /home/matt/src
	wget http://llvm.org/releases/$LLVM_VER/llvm-$LLVM_VER.tgz
	tar xzvf llvm-$LLVM_VER.tgz
	cd llvm-$LLVM_VER/tools
	wget http://llvm.org/releases/$LLVM_VER/clang-$LLVM_VER.tgz
	tar xzvf clang-$LLVM_VER.tgz
	cd ..
	./configure --enable-optimized
	make -j3
	. /home/matt/.bash_profile #Or else the previous PATH modifications won't carry over.
	echo "PATH=/home/matt/src/llvm-$LLVM_VER/Release/bin:$PATH" >> /home/matt/.bash_profile
fi

#http://www.freetechie.com/blog/disable-nepomuk-desktop-search-on-kde-4-4-2-kubuntu-lucid-10-04/
mkdir -p /home/matt/.kde/share/apps/konversation/
ln -s /home/matt/Dropbox/konversationui.rc /home/matt/.kde/share/apps/konversation/
chown -R matt:matt /home/matt/.kde/share/apps/konversation/
mkdir -p /home/matt/.kde/share/config/
ln -s /home/matt/Dropbox/konversationrc /home/matt/.kde/share/config/
chown -R matt:matt /home/matt/.kde/share/config/

cd /home/matt/src
wget http://dl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb
dpkg -i --force-depends google-chrome-unstable_current_amd64.deb
apt-get -yf install
cp /opt/google/chrome/libpdf.so /usr/lib/chromium-browser

#ar vx google-chrome-unstable_current_amd64.deb
#unlzma data.tar.lzma
#tar xvf data.tar
#cp opt/google/chrome/libpdf.so /usr/lib/chromium-browser

sed -i 's/Exec=\/usr\/bin\/chromium-browser %U/Exec=\/usr\/bin\/chromium-browser --password-store=basic %U/' /usr/share/applications/chromium-browser.desktop

cd /home/matt/src
svn co http://rbeq.googlecode.com/svn/trunk/ rbeq
cd rbeq
cp -R rhythmbox /home/matt/.gnome2
cd /home/matt/.local/share
rm -rf rhythmbox
ln -s /home/matt/Dropbox/rhythmbox/ rhythmbox

ln -s /home/matt/Dropbox/ssh_config /home/matt/.ssh/config
chmod 600 /home/matt/.ssh/config
sed -i 's/    HashKnownHosts yes/    HashKnownHosts no/' /etc/ssh/ssh_config

mkdir /home/matt/Deluge_Incoming
chown -R matt:matt /home/matt/Deluge_Incoming
mkdir -p /home/matt/.config/deluge
for f in /home/matt/Dropbox/deluge/*; do ln -s $f /home/matt/.config/deluge/`basename $f`; done
chown -R matt:matt /home/matt/.config/deluge/

mkdir -p /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/accounts.xml /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/logs/ /home/matt/.purple/
ln -s /home/matt/Dropbox/purple/prefs.xml /home/matt/.purple/
chown -R matt:matt /home/matt/.purple/

#gconftool-2 --set /apps/metacity/general/button_layout --type string ":"
su -l matt -c "gconftool --set /apps/compiz-1/general/screen0/options/hsize --type=int 3"
su -l matt -c "gconftool --set /apps/compiz-1/general/screen0/options/vsize --type=int 2"

apt-get -y remove empathy-common evolution-common transmission-common ubuntuone-client-gnome banshee gwibber

su -l matt -c "gconftool-2 -t string -s /desktop/gnome/url-handlers/magnet/command 'deluge "%s"'"
su -l matt -c "gconftool-2 -t bool -s /desktop/gnome/url-handlers/magnet/needs_terminal false"
su -l matt -c "gconftool-2 -t bool -s /desktop/gnome/url-handlers/magnet/enabled true"
su -l matt -c "xdg-mime default deluge.desktop x-scheme-handler/magnet"
sed -i 's/Exec=deluge-gtk/Exec=deluge-gtk %U/' /usr/share/applications/deluge.desktop
