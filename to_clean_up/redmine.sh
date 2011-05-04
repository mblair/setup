#TODO: Migrate this to ChiliProject.

#!/usr/bin/env bash

set -e #quits on error
set -x #prints executed statements with a '+' in front

if [[ `cat /etc/*-release | awk '{print $1}' -` = "CentOS" ]]; then
	OS="CentOS"
elif [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
then
	OS="Ubuntu"
else
	OS="neither" # Debian is on the roadmap.
fi

#Versions
PASSENGER_VER=3.0.2
NGINX_VER=0.8.54
REDMINE_VER=1.1.1
REDMINE_RUBY_VER=1.8.7
RUBY_PATCHLEVEL=330 #TODO: Grab this from RVM's config/known
REDMINE_RAILS_VER=2.3.5 #grrrr
IMAGEMAGICK_VER=6.6.7-4
POSTGRES_VER=9.0.3

if [ $OS = "CentOS" ]; then
	yum install -y bison readline-devel libxml2-devel
else
	apt-get install -y bison libreadline5-dev libxml2-dev
fi

rvm install $REDMINE_RUBY_VER
rvm --create use $REDMINE_RUBY_VER@redmine
rvm use $REDMINE_RUBY_VER@redmine --default
rvm $REDMINE_RUBY_VER@redmine #TODO: Figure out if/why this is necessary.
. ~/.bashrc

cd /opt
git clone http://github.com/FooBarWidget/passenger.git
cd passenger
git co release-$PASSENGER_VER

if [ $OS = "CentOS" ]; then
	yum install -y pcre-devel
else
	apt-get install -y libpcre3-dev
fi

cd /opt
wget "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
tar xzvf "nginx-$NGINX_VER.tar.gz"
cd "nginx-$NGINX_VER"
./configure --prefix=/opt/nginx --with-debug --user=nginx --group=nginx --with-http_ssl_module --with-sha1=auto/lib/sha1 --with-sha1-asm --with-http_flv_module --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --add-module=/opt/passenger/ext/nginx
make -j4
make install

if [ $OS = "CentOS" ]; then
	groupadd -r nginx
	adduser -M -r -g nginx nginx
else
	adduser --system --no-create-home --disabled-login --disabled-password --group nginx
fi

#TODO: Clean this up.
if [ $OS = "CentOS" ]; then
	wget http://library.linode.com/web-servers/nginx/installation/reference/init-rpm.sh
	cp init-rpm.sh /etc/init.d/nginx
else
	wget http://library.linode.com/web-servers/nginx/installation/reference/init-deb.sh
	cp init-deb.sh /etc/init.d/nginx
	sed -i 's/\/opt\/nginx\/logs\/$NAME.pid/\/var\/run\/nginx.pid/' /etc/init.d/nginx
fi

chmod +x /etc/init.d/nginx

if [ $OS = "CentOS" ]; then
	chkconfig --add nginx
	chkconfig nginx on
else
	update-rc.d -f nginx defaults
fi

chown -R nginx:nginx /var/log/nginx/

cat > /opt/nginx/conf/nginx.conf << "EOF"
	user  nginx;
	worker_processes  4;

	events {
		worker_connections  1024;
	}


	http {
		include mime.types;
		default_type application/octet-stream;

		log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
						'$status $body_bytes_sent "$http_referer" '
						'"$http_user_agent" "$http_x_forwarded_for" "$gzip_ratio"';

		sendfile on;

		keepalive_timeout  65;

		gzip  on;
		gzip_comp_level 1;
		gzip_vary on;
		gzip_types text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript application/json;
		gzip_buffers 16 8k;
		server_tokens off;

		include /opt/nginx/conf/sites-enabled/*;
    client_body_buffer_size 128k;
		client_max_body_size 50m;
		passenger_root /opt/passenger;
		passenger_user nginx;
	}
EOF
sed -i 's/^\t//' /opt/nginx/conf/nginx.conf
sed -i "/^\tpassenger_root/a passenger_ruby \/usr/local\/rvm/wrappers\/ruby-$REDMINE_RUBY_VER-p$RUBY_PATCHLEVEL@redmine\/ruby;" /opt/nginx/conf/nginx.conf #TODO: Figure out if the previous heredoc mangles interpolation; if not, move this up there.
sed -i '/^passenger_ruby/s/^p/\tp/' /opt/nginx/conf/nginx.conf
cd /opt/nginx/conf
mkdir sites-available
mkdir sites-enabled

#vroom vroommmm
echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
echo 'update: --no-rdoc --no-ri' >> ~/.gemrc

gem install rails -v $REDMINE_RAILS_VER
gem install fastthread
gem install -v=0.4.2 i18n

cd /srv
git clone https://github.com/edavis10/redmine.git 
cd redmine
git co $REDMINE_VER
#ruby script/plugin install git://github.com/collectiveidea/action_mailer_optional_tls.git #try without this first, the redmine docs say it might not be needed with recent rubies.

cat > /opt/nginx/conf/sites-available/redmine << "EOF"
	server {
		listen 80;
		server_name localhost;
		access_log /var/log/nginx/redmine_access.log main;
		error_log /var/log/nginx/redmine_error.log info;
		root /srv/redmine/public;
		passenger_enabled on;
	}
EOF
sed -i 's/^\t//' /opt/nginx/conf/sites-available/redmine

cd /opt/nginx/conf/sites-enabled
ln -s /opt/nginx/conf/sites-available/redmine redmine

if [ $OS = "CentOS" ]; then
	yum install -y libpng-devel ghostscript-devel #or Gantt charts won't work.
fi

cd /opt
wget ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-$IMAGEMAGICK_VER.tar.bz2
tar xjvf ImageMagick-$IMAGEMAGICK_VER.tar.bz2
cd ImageMagick-$IMAGEMAGICK_VER
./configure
make -j4
make install
ldconfig /usr/local/lib #necessary on CentOS 5, apparently.
gem install rmagick

cd /opt
wget http://wwwmaster.postgresql.org/redir/198/h/source/v$POSTGRES_VER/postgresql-$POSTGRES_VER.tar.bz2 
tar xjvf postgresql-$POSTGRES_VER.tar.bz2
cd postgresql-$POSTGRES_VER
./configure
make -j4
checkinstall make install-world #installs man pages too.
. ~/.bash_profile
echo "PATH=$PATH:/usr/local/pgsql/bin" >> ~/.bash_profile
echo "MANPATH=$MANPATH:/usr/local/pgsql/share/man" >> ~/.bash_profile
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

#TODO: if the previous heredoc investigation turns out OK, make the following redmine DB passwords variable.
cat > /home/postgres/script.sh << "EOF"
	/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
	/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data > logfile 2>&1 &
	sleep 10 # Give PG time to start.
	/usr/local/pgsql/bin/createdb test
	/usr/local/pgsql/bin/psql -c "ALTER USER postgres WITH PASSWORD 'pgpass'"
	/usr/local/pgsql/bin/psql -c "CREATE ROLE redmine LOGIN ENCRYPTED PASSWORD 'redminepass' NOINHERIT VALID UNTIL 'infinity';"
	/usr/local/pgsql/bin/psql -c "CREATE DATABASE redmine WITH ENCODING='UTF8' OWNER=redmine;"
EOF
sed -i 's/^\t//' /home/postgres/script.sh
chmod +x /home/postgres/script.sh
su postgres -c 'cd && ./script.sh' #Not sure if that cd is needed. su postgres starts me in /home/postgres.
echo 'localhost:*:*:postgres:pgpass' > ~/.pgpass #might want to change that.
chmod 0600 ~/.pgpass
sed -i '/^local.*trust$/s/trust/password/g' /usr/local/pgsql/data/pg_hba.conf
sed -i '/^host.*trust$/s/trust/password/g' /usr/local/pgsql/data/pg_hba.conf
/etc/init.d/postgres restart

# Two spaces after c\ due to YAML whitespace sensitivity.
cd /srv/redmine/config/
cp database.yml.example database.yml
sed -i '10,$d' database.yml
sed -i '/adapter: mysql$/ c\  adapter: postgresql' database.yml
sed -i '/username: root$/ c\  username: redmine' database.yml
sed -i "/^  password:/ c\  password: redminepass" database.yml
sed -i "/^encoding/a  schema_search_path: public/" database.yml
cp additional_environment.rb.example additional_environment.rb

# Log rotation
echo "config.logger = Logger.new(config.log_path, 2, 1000000)" >> additional_environment.rb
echo "config.logger.level = Logger::INFO" >> additional_environment.rb
cd ..

. ~/.bashrc #rvm gets on my nerves sometimes
rake generate_session_store

gem install pg -- --with-pg-dir=/usr/local/pgsql #since you installed from source, unnecessary otherwise.

RAILS_ENV=production rake db:migrate #problematic
REDMINE_LANG=en RAILS_ENV=production rake redmine:load_default_data
#mkdir public/plugin_assets # no longer necessary?
sudo chown -R nginx:nginx files log tmp public/plugin_assets
sudo chmod -R 755 files log tmp public/plugin_assets

if [ $OS = "CentOS"]; then
	echo "rvm $REDMINE_RUBY_VER@redmine" >> ~/.bashrc #seems to be the only way to get rvm to work on login on CentOS 5.
fi

/etc/init.d/nginx start

#See backup for backup/restore info.
echo "Done!"

#TODO: Get email working.
#config/email.yml:
 #production:
   #delivery_method: :smtp
   #smtp_settings:
     #tls: true
     #address: "smtp.gmail.com"
     #port: 587
     #domain: "example.com" # 'your.domain.com' for GoogleApps
     #authentication: :plain
     #user_name: "user@example.com"
     #password: "changeme"
