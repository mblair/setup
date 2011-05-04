#!/usr/bin/env bash

#TODO: Test with lucid/maverick/natty, make separate workstation/server versions. Workstation uses /home/matt/.gemrc (instead of /root/.gemrc) and rails s for hosting, while the server uses nginx + Passenger. Locally, chown -R matt:matt first_app/ to get `rails s` working. Although when you run `rails new blah` as matt, blah is owned by matt. Whatever.
#TODO: Test on CentOS, Debian 5, Debian 6, Ubuntu LTS, Maverick, Natty.

. ~/bare.sh

set -e
set -x

#Versions
PASSENGER_VER=3.0.6
NGINX_VER=0.8.54

. /usr/local/lib/rvm

if [ $OS = "CentOS" ]; then
	yum install -y bison readline-devel libxml2-devel libxslt-devel autoconf subversion
else
	apt-get install -y bison libreadline6-dev libxml2-dev libxslt1-dev subversion autoconf # xslt1-dev is for nokogiri, subversion and autoconf are for -head
fi

rvm install 1.9.2-head
rvm --create use 1.9.2-head@rails3tutorial
rvm use 1.9.2-head@rails3tutorial --default
rvm 1.9.2-head@rails3tutorial
. /usr/local/lib/rvm #this is so rake works when configuring nginx (which compiles passenger) #TODO: Try `. /usr/local/lib/rvm` again	

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
fi

chmod +x /etc/init.d/nginx

if [ $OS = "CentOS" ]; then
	chkconfig --add nginx
	chkconfig nginx on
else
	update-rc.d -f nginx defaults
fi

cd /var/log
chown -R nginx:nginx nginx/

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
		client_max_body_size 50m;
		passenger_root /opt/passenger;
		passenger_ruby /usr/local/rvm/wrappers/ruby-1.9.2-head@rails3tutorial/ruby;
		passenger_user nginx;
	}
EOF
sed -i 's/^\t//' /opt/nginx/conf/nginx.conf
cd /opt/nginx/conf
mkdir sites-available
mkdir sites-enabled

#vroom vroommmm
echo 'install: --no-rdoc --no-ri' >> ~/.gemrc
echo 'update: --no-rdoc --no-ri' >> ~/.gemrc
gem install fastthread

gem install rails
gem update #perhaps this speeds up bundler, can't remember
cd /srv
mkdir rails_projects
cd rails_projects
rails new first_app
cd first_app
bundle install
rake db:migrate

# Are these necessary at all? I remember putting these here for SQLite.
chown -R nginx:nginx db/
chmod -R aou+rwx db/ 

#This is possibly a bad idea, since you don't have a good .gitignore yet. Might not matter.
git init
git add .
git commit -m 'Initial commit'

cat > /opt/nginx/conf/sites-available/rails3tutorial << "EOF"
	server {
		listen 80;
		server_name localhost;
		access_log /var/log/nginx/rails3tutorial_access.log main;
		error_log /var/log/nginx/rails3tutorial_error.log info;
		root /srv/rails_projects/first_app/public;
		passenger_enabled on;
	}
EOF
sed -i 's/^\t//' /opt/nginx/conf/sites-available/rails3tutorial

cd /opt/nginx/conf/sites-enabled
ln -s /opt/nginx/conf/sites-available/rails3tutorial rails3tutorial

/etc/init.d/nginx start

echo "Done!"
