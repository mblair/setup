if [ $python == "yes" ]; then
	cd /home/matt/src
	wget http://python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tar.bz2
	tar xjvf Python-$PYTHON_VER.tar.bz2
	cd Python-$PYTHON_VER

	#Attempting to cope with this foolishness:
	#https://wiki.ubuntu.com/MultiarchSpec
	#http://bugs.python.org/issue11715
	#curl http://hg.python.org/cpython/raw-rev/bd0f73a9538e > barry_multiarch_patch
	#patch -p1 < barry_multiarch_patch

	./configure --with-threads --enable-shared
	mkdir /tmp/pydir
	make -j3 DESTDIR=/tmp/pydir
	make install DESTDIR=/tmp/pydir
	chown -R matt:matt /tmp/pydir /home/matt/src/Python-$PYTHON_VER
	su -l matt -c "cd /home/matt/src/Python-$PYTHON_VER && fpm -s dir -t deb -n python -v $PYTHON_VER -C /tmp/pydir"

	if [ $ARCH -eq 64 ]; then
		dpkg -i python_"$PYTHON_VER"_amd64.deb
	else
		dpkg -i python_"$PYTHON_VER"_i386.deb
	fi

	#echo "alias python='/home/matt/src/python$PYTHON_VER/bin/python'" >> /home/matt/.bash_profile
	#echo "alias python$PYTHON_SHORT_VER='/home/matt/src/python$PYTHON_VER/bin/python'" >> /home/matt/.bash_profile

	##TODO: Figure out why you're appending instead of prepending.
	#echo "PATH=$PATH:/home/matt/src/python$PYTHON_VER/bin" >> /home/matt/.bash_profile

	#echo "/home/matt/src/python$PYTHON_VER/lib" > /etc/ld.so.conf.d/python$PYTHON_VER.conf
	#ldconfig

	#TODO: What's this for again? Mercurial maybe?
	#echo "PYTHONPATH=/home/matt/src/python$PYTHON_VER/lib/python$PYTHON_VER/" >> /home/matt/.bash_profile
	#echo  "PATH=/usr/local/bin:$PATH" >> /home/matt/.bash_profile
	#. /home/matt/.bash_profile # So I have access to those aliases.

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
fi

cd /home/matt/src
curl -O http://python-distribute.org/distribute_setup.py
python distribute_setup.py

curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py

if [ $python = "yes" ]; then
	wget http://mercurial.selenic.com/release/mercurial-$HG_VER.tar.gz
	tar xzvf mercurial-$HG_VER.tar.gz
	cd mercurial-$HG_VER
	mkdir /tmp/hgdir
	#make install-bin PYTHON=/home/matt/src/python$PYTHON_VER/bin/python PREFIX=/home/matt/src/python$PYTHON_VER DESTDIR=/tmp/hgdir
	make install-bin DESTDIR=/tmp/hgdir
	chown -R matt:matt /tmp/hgdir /home/matt/src/mercurial-$HG_VER
	su -l matt -c "cd /home/matt/src/mercurial-$HG_VER && fpm -s dir -t deb -n mercurial -v $HG_VER -C /tmp/hgdir"
	if [ $ARCH -eq 64 ]; then
		dpkg -i mercurial_$HG_VER\_amd64.deb
	else
		dpkg -i mercurial_$HG_VER\_i386.deb
	fi
else
	apt-get -y install python-dev
	pip install mercurial
fi

pip install sphinx #installs pygments and docutils
#fabric, virtualenv
