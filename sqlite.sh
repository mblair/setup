cd /home/matt/src
wget http://sqlite.org/sqlite-autoconf-$SQLITE_VER.tar.gz
tar xzvf sqlite-autoconf-$SQLITE_VER.tar.gz
cd sqlite-autoconf-$SQLITE_VER
./configure
make -j4
checkinstall make install
