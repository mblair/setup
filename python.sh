if [ $OS = "CentOS" ]; then
	yum -y install bzip2-devel gdbm-devel
else
	aptitude -y install libbz2-dev libgdbm-dev
fi

cd /home/matt/src
wget http://python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tar.bz2
tar xjvf Python-$PYTHON_VER.tar.bz2
cd Python-$PYTHON_VER

#Attempting to cope with this foolishness:
#https://wiki.ubuntu.com/MultiarchSpec
awk "{print} /'\/lib64/{print \"            '/usr/lib/i386-linux-gnu', '/usr/lib/x86_64-linux-gnu'\"}" setup.py > setup.py

./configure --prefix=/home/matt/src/python$PYTHON_VER --with-threads --enable-shared
make -j4
make install #Not dangerous. Peep the prefix.
touch /home/matt/.bash_profile
chown matt:matt /home/matt/.bash_profile
echo "alias python='/home/matt/src/python$PYTHON_VER/bin/python'" >> /home/matt/.bash_profile
echo "alias python$PYTHON_SHORT_VER='/home/matt/src/python$PYTHON_VER/bin/python'" >> /home/matt/.bash_profile

#TODO: Figure out why you're appending instead of prepending.
echo "PATH=$PATH:/home/matt/src/python$PYTHON_VER/bin" >> /home/matt/.bash_profile

echo "/home/matt/src/python$PYTHON_VER/lib" > /etc/ld.so.conf.d/python$PYTHON_VER.conf
ldconfig

#TODO: What's this for again? Mercurial maybe?
echo "PYTHONPATH=/home/matt/src/python$PYTHON_VER/lib/python$PYTHON_VER/" >> /home/matt/.bash_profile
. /home/matt/.bash_profile # So I have access to those aliases.

#TODO: Install Python 3 when folks are actually using it.
#cd /home/matt/src
#wget http://www.python.org/ftp/python/$PYTHON3_SHORT_VER/Python-$PYTHON3_VER.tar.bz2
#tar xjvf Python-$PYTHON3_VER.tar.bz2
#cd Python-$PYTHON3_VER
#./configure --prefix=/home/matt/src/python$PYTHON3_VER --with-threads --enable-shared
#make -j4
#make install
#echo "alias python3='/home/matt/src/python$PYTHON3_VER/bin/python3'" >> ~/.bash_profile
#echo "alias python$PYTHON3_SHORT_VER='/home/matt/src/python$PYTHON3_VER/bin/python3'" >> ~/.bash_profile
#echo "PATH=$PATH:/home/matt/src/python$PYTHON3_VER/bin" >> ~/.bash_profile
#echo "/home/matt/src/python$PYTHON3_VER/lib" >> /etc/ld.so.conf.d/python$PYTHON3_VER.conf
#ldconfig
#echo "PYTHONPATH=/home/matt/src/python$PYTHON_VER/lib/python$PYTHON_VER/:$PYTHONPATH" >> ~/.bash_profile

cd /home/matt/src
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py

wget http://mercurial.selenic.com/release/mercurial-$HG_VER.tar.gz 
tar xzvf mercurial-$HG_VER.tar.gz
cd mercurial-$HG_VER
checkinstall make install-bin PYTHON=/home/matt/src/python$PYTHON_VER/bin/python PREFIX=/home/matt/src/python$PYTHON_VER

curl -O https://github.com/pypa/pip/raw/master/contrib/get-pip.py
python get-pip.py

#Pygments, fabric, virtualenv, docutils.
