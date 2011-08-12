cd /home/matt/src

#For node >= 0.5.0
#wget http://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER.tar.gz
wget http://nodejs.org/dist/node-v$NODE_VER.tar.gz
tar xzvf node-v$NODE_VER.tar.gz
cd node-v$NODE_VER
./configure
make -j3
mkdir /tmp/nodedir
make install DESTDIR=/tmp/nodedir
chown -R matt:matt /tmp/nodedir /home/matt/src/node-v$NODE_VER

su -l matt -c "cd /home/matt/src/node-v$NODE_VER && fpm -s dir -t deb -n nodejs -v $NODE_VER -C /tmp/nodedir -p nodejs-VERSION_ARCH.deb"

if [ $ARCH -eq 64 ]; then
	dpkg -i nodejs-"$NODE_VER"_amd64.deb
else
	dpkg -i nodejs-"$NODE_VER"_i386.deb
fi

curl http://npmjs.org/install.sh | sh

echo 'export PATH=/usr/local/share/npm/bin:$PATH' >> /home/matt/.bash_profile
echo 'export NODE_PATH=/usr/local/lib/node_modules:/usr/local/node_modules' >> /home/matt/.bash_profile
