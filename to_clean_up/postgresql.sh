#Determine prereqs for CentOS and Ubuntu.

cd /home/matt/src
wget http://wwwmaster.postgresql.org/redir/198/h/source/v$POSTGRES_VER/postgresql-$POSTGRES_VER.tar.bz2 
tar xjvf postgresql-$POSTGRES_VER.tar.bz2
cd postgresql-$POSTGRES_VER
./configure
make -j4
checkinstall --fstrans=no make install-world #installs man pages too.
echo 'PATH=$PATH:/usr/local/pgsql/bin' >> /home/matt/.bash_profile
echo '/usr/local/pgsql/lib' > /etc/ld.so.conf.d/pgsql.conf
echo 'MANPATH=$MANPATH:/usr/local/pgsql/share/man' >> /home/matt/.bash_profile
cp contrib/start-scripts/linux /etc/init.d/postgres
chmod a+x /etc/init.d/postgres

if [ $OS = "CentOS" ]; then
	chkconfig --add postgres
	chkconfig postgres on
else 
	update-rc.d postgres defaults
fi

if [ $OS = "CentOS" ]; then
	adduser -m -r postgres
else
	adduser postgres --disabled-password --gecos ""
fi

mkdir /usr/local/pgsql/data
chown postgres /usr/local/pgsql/data

cat > /home/postgres/script.sh << "EOF"
	/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
	/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data > logfile 2>&1 &
	sleep 10 # Give PG time to start.
	/usr/local/pgsql/bin/createdb test
	/usr/local/pgsql/bin/psql -c "ALTER USER postgres WITH PASSWORD 'pgpass'"
EOF
sed -i 's/^\t//' /home/postgres/script.sh
chmod +x /home/postgres/script.sh
su postgres -c 'cd && ./script.sh' #Not sure if that cd is needed. su postgres starts me in /home/postgres.
echo 'localhost:*:*:postgres:pgpass' > /home/matt/.pgpass #might want to change that.
chown matt:matt /home/matt/.pgpass
chmod 0600 /home/matt/.pgpass
sed -i '/^local.*trust$/s/trust/password/g' /usr/local/pgsql/data/pg_hba.conf
sed -i '/^host.*trust$/s/trust/password/g' /usr/local/pgsql/data/pg_hba.conf
/etc/init.d/postgres restart

#gem install pg -- --with-pg-dir=/usr/local/pgsql #For apps you're developing.
# - OR - #
#bundle config build.pg --with-pg-dir=/usr/local/pgsql/ #For stuff whose gems you've installed via Bundler (Heroku apps, etc).
