set -e
set -x

APACHE_VER=2.2.19

cd /home/matt/src
wget http://www.apache.org/dist/httpd/httpd-$APACHE_VER.tar.bz2
tar xjvf httpd-$APACHE_VER.tar.bz2
cd httpd-$APACHE_VER
#TODO: Figure out if --enable-mods-shared=all is necessary for mod_rewrite.
./configure --enable-deflate --enable-ssl --enable-mods-shared=all --enable-so
make -j4
checkinstall --fstrans=no make install
cp /usr/local/apache2/bin/apachectl /etc/init.d/apache
chmod +x /etc/init.d/apache
sed -i '2i #' /etc/init.d/apache
sed -i '3i # chkconfig: - 85 15' /etc/init.d/apache
sed -i '4i # description: Apache is a web server.' /etc/init.d/apache
update-rc.d apache defaults
adduser --system -no-create-home apache
cp /usr/local/apache2/conf/httpd.conf{,.default}
mkdir /etc/apache
ln -s /usr/local/apache2/conf/httpd.conf /etc/apache/httpd.conf
sed -i 's/User daemon/User apache/' /usr/local/apache2/conf/httpd.conf
sed -i 's/Group daemon/Group nogroup/' /usr/local/apache2/conf/httpd.conf
sed -i 's/^#ServerName.*$/ServerName 97.107.131.68/' /etc/apache/httpd.conf
sed -i 's/^ServerAdmin.*$/ServerAdmin me@matthewblair.net/' /etc/apache/httpd.conf
/etc/init.d/apache start
