#TODO: Find some man pages for this.
cd /home/matt/src
git clone http://checkinstall.izto.org/checkinstall.git
cd checkinstall

make -j4
make install #No choice.

#This works around nosuid tmp dirs that hosts like Burstnet use.
alias checkinstall='BASE_TMP_DIR=/var/checkinstall checkinstall'
mkdir /var/checkinstall

if [ $OS = "CentOS" ]; then
	checkinstall -y --install=no -d2 -R
	echo 'INSTYPE="R"' > /usr/local/checkinstallrc
else
	checkinstall -y --install=no -d2 -D
	echo 'INSTYPE="D"' > /usr/local/checkinstallrc
fi

#TODO: Find out if checkinstalling checkinstall overwrites these, or if you can set them earlier and have them take effect the first time
# checkinstall is run. Also fit more `checkinstall`s into that previous sentence.
#TODO: Make this a heredoc.
echo "ACCEPT_DEFAULT=1" >> /usr/local/checkinstallrc
echo "INSTALL=1" >> /usr/local/checkinstallrc
echo "DEBUG=2" >> /usr/local/checkinstallrc
echo "BASE_TMP_DIR=/var/checkinstall" >> /usr/local/checkinstallrc
