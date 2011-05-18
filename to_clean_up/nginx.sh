#!/usr/bin/env bash

#TODO: Read this: http://wiki.nginx.org/Pitfalls

#http://stackoverflow.com/questions/192319/in-the-bash-script-how-do-i-know-the-script-file-name/639500#639500
if [ $0 == $BASH_SOURCE ]; then
	echo "Do not run this file directly."
	exit 1
else
	: #This file is being sourced from somewhere, hopefully setup.sh.
fi

MP4_STREAMING=0

if [ $MP4_STREAMING -eq 1 ]; then
	cd /home/matt/src/
	wget http://h264.code-shop.com/download/nginx_mod_h264_streaming-2.2.7.tar.gz
	tar xzvf nginx_mod_h264_streaming-2.2.7.tar.gz

	#http://h264.code-shop.com/trac/discussion/1/133?discussion_action=quote;
	sed -i '157,162d' nginx_mod_h264_streaming-2.2.7/src/ngx_http_streaming_module.c
fi

cd /home/matt/src/
wget "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
tar xzvf "nginx-$NGINX_VER.tar.gz"
cd "nginx-$NGINX_VER"

if [ $MP4_STREAMING -eq 1]; then
	./configure --prefix=/opt/nginx --with-debug --user=nginx --group=nginx --with-http_ssl_module --with-sha1=auto/lib/sha1 --with-sha1-asm --with-http_flv_module --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid --add-module=/home/matt/src/nginx_mod_h264_streaming-2.2.7
else
	./configure --prefix=/opt/nginx --with-debug --user=nginx --group=nginx --with-http_ssl_module --with-sha1=auto/lib/sha1 --with-sha1-asm --with-http_flv_module --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid
fi

if [ $variant == "server" ]; then
	make -j5
else
	make -j3 #TODO: Get a 4-core workstation :-)
fi

checkinstall make install #TODO: Figure out when/why this doesn't create /var/log/nginx (<- ?)

#TODO: Use the useradd lines from setup.sh here, take a look at the Linode Library ones too.
if [ $OS == "Ubuntu" ]; then
	adduser --system --no-create-home --disabled-login --disabled-password --group nginx
else
	groupadd -r nginx
	adduser -M -r -g nginx nginx
fi

if [ $OS == "Ubuntu" ]; then
	wget http://library.linode.com/assets/661-init-deb.sh
	mv 661-init-deb.sh /etc/init.d/nginx
	sed -i 's/\/opt\/nginx\/logs\/$NAME.pid/\/var\/run\/nginx.pid/' /etc/init.d/nginx
else
	wget http://library.linode.com/assets/662-init-rpm.sh
	mv 662-init-rpm.sh /etc/init.d/nginx
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
