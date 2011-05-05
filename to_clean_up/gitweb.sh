#TODO: separate post-receive diff emails for app and infra.
#TODO: post-receive infrastructure hooks (swap out config & restart)
#TODO: cgit

set -e
set -x

adduser git --disabled-password --gecos ""
mkdir /opt/git
chown -R git:git /opt/git
cat ~/.ssh/authorized_keys > /home/git/keys.pub
cat > /home/git/script.sh << "EOF"
	mkdir .ssh
	cat keys.pub > .ssh/authorized_keys
	cd /opt/git
	mkdir test.git
	cd test.git
	git --bare init
	echo "Test project." > description
	echo "[gitweb]" >> config
	echo 'owner = "Matt Blair"' >> config
	sed -i '/owner/s/^/\t/' config
	mv hooks/post-update.sample hooks/post-update
	chmod a+x hooks/post-update
	./hooks/post-update
EOF
sed -i 's/^\t//' /home/git/script.sh
chmod +x /home/git/script.sh
su git -c 'cd && ./script.sh'

chown -R apache /opt/git

cd /home/matt/src/git-1.7.4.1/
make GITWEB_PROJECTROOT="/opt/git" prefix=/usr/local gitweb/gitweb.cgi
cp -Rf gitweb /srv/

cat > /etc/apache/git.conf << "EOF"
	NameVirtualHost *:80

	UseCanonicalName off
	<VirtualHost *:80>
		ServerName git.tayoblair.com
		DocumentRoot /opt/git
		<Directory /opt/git>
			Options Indexes
			Order allow,deny
			allow from all
		</Directory>
	</VirtualHost>
	<VirtualHost *:80>
		ServerName tayoblair.com
		DocumentRoot /srv/gitweb
		<Directory /srv/gitweb>
			Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
			AllowOverride All
			order allow,deny
			Allow from all
			AddHandler cgi-script cgi
			DirectoryIndex gitweb.cgi
		</Directory>
	</VirtualHost>
EOF
sed -i 's/^\t//' /etc/apache/git.conf
echo 'Include /etc/apache/git.conf' >> /etc/apache/httpd.conf
/etc/init.d/apache restart

sed -i '/git/s/\/bin\/bash/\/usr\/local\/bin\/git-shell/g' /etc/passwd

cd
git clone /opt/git/test.git
cd test
touch README
git add README
git commit -m 'initial'
git push origin master
echo "Done!"
