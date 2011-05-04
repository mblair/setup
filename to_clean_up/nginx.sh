#!/usr/bin/env bash

set -e
set -x

NGINX_VER=1.0.0 #http://nginx.org/en/download.html 

if [[ `cat /etc/*-release | awk '{print $1}' -` = "CentOS" ]]; then
	OS="CentOS"
elif [[ `cat /etc/*-release | head -n1 | awk -F= '{print $2}' -` = "Ubuntu" ]]
then
	OS="Ubuntu"
else
	OS="neither" # Debian is on the roadmap.
fi

#TODO
if [ $OS = "Ubuntu" ]; then
	apt-get -y install libpcre3-dev
else
	yum install -y pcre-devel
fi

cd /opt
wget "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
tar xzvf "nginx-$NGINX_VER.tar.gz"
cd "nginx-$NGINX_VER"
./configure --prefix=/opt/nginx --with-debug --user=nginx --group=nginx --with-http_ssl_module --with-sha1=auto/lib/sha1 --with-sha1-asm --with-http_flv_module --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid
make -j4
checkinstall make install #TODO: Figure out when/why this doesn't create /var/log/nginx

if [ $OS = "Ubuntu" ]; then
	adduser --system --no-create-home --disabled-login --disabled-password --group nginx
else
	groupadd -r nginx
	adduser -M -r -g nginx nginx
fi

if [ $OS = "Ubuntu" ]; then
	wget http://library.linode.com/web-servers/nginx/installation/reference/init-deb.sh
	mv init-deb.sh /etc/init.d/nginx
	sed -i 's/\/opt\/nginx\/logs\/$NAME.pid/\/var\/run\/nginx.pid/' /etc/init.d/nginx
else
	wget http://library.linode.com/web-servers/nginx/installation/reference/init-rpm.sh
	mv init-rpm.sh /etc/init.d/nginx
fi
chmod +x /etc/init.d/nginx

if [ $OS = "Ubuntu" ]; then
	update-rc.d nginx defaults
else
	chkconfig nginx on
fi

cat > /opt/nginx/conf/nginx.conf << "EOF"
	user  nginx;
	worker_processes  4;

	events {
		worker_connections  1024;
	}


	http {
		include       mime.types;
		default_type  application/octet-stream;

		log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
						'$status $body_bytes_sent "$http_referer" '
						'"$http_user_agent" "$http_x_forwarded_for" "$gzip_ratio"';

		sendfile        on;

		keepalive_timeout  65;

		gzip  on;
		gzip_comp_level 1;
		gzip_vary on;
		gzip_types text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript application/json;
		gzip_buffers 16 8k;
		server_tokens off;
		
		include 	/opt/nginx/conf/sites-enabled/*;
		client_max_body_size 50m;
	}
EOF
sed -i 's/^\t//' /opt/nginx/conf/nginx.conf
cd /opt/nginx/conf
mkdir sites-available
mkdir sites-enabled

cd /var/log
test -d /var/log/nginx || mkdir nginx
chown -R nginx:nginx nginx/

service nginx start
