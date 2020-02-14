#!/bin/bash
set -e
if [ -f /etc/apache2/sites-available/vhost-website.conf ]; then
 rm /etc/apache2/sites-available/vhost-website.conf
fi

if [ -z "$WEBSITE_HOST" ]; then
	WEBSITE_HOST="website.dev.acti"
fi
if [ "$SYMFONY_VHOST_COMPLIANT" == "yes" ]; then
	SUFFIX="/web"
fi
if [ "$VHOST_SUFFIX" != "" ]; then
  SUFFIX="/$VHOST_SUFFIX"
fi

cat <<EOF >> /etc/apache2/sites-available/vhost-website.conf
<VirtualHost *:80>
        ServerName $WEBSITE_HOST
        ServerAlias *.$WEBSITE_HOST
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/website$SUFFIX

        ErrorLog /proc/self/fd/2
        CustomLog /proc/self/fd/1 combined

        <Directory /var/www/website$SUFFIX>
          Require all granted	
          Options -Indexes +FollowSymLinks -MultiViews
          Order allow,deny
          allow from all
	       AllowOverride All
        </Directory>

        <FilesMatch \.php$>
            SetHandler "proxy:fcgi://php:9000"
        </FilesMatch>

</VirtualHost>
<VirtualHost *:443>
        ServerName $WEBSITE_HOST
        ServerAlias *.$WEBSITE_HOST
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/website$SUFFIX

        ErrorLog /proc/self/fd/2
        CustomLog /proc/self/fd/1 combined

        <Directory /var/www/website$SUFFIX>
          Require all granted
          Options -Indexes +FollowSymLinks -MultiViews
          Order allow,deny
          allow from all
              AllowOverride All
        </Directory>
        
        SSLEngine on
        SSLCertificateFile    /etc/apache2/ssl/ssl.crt
        SSLCertificateKeyFile /etc/apache2/ssl/ssl.key
        BrowserMatch "MSIE [2-6]" \
                nokeepalive ssl-unclean-shutdown \
                downgrade-1.0 force-response-1.0
        BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
        RequestHeader set X-Forwarded-Proto "https"

        <FilesMatch \.php$>
          SetHandler "proxy:fcgi://php:9000"
        </FilesMatch>
</VirtualHost>
EOF

#if [ "$CERTIFICAT_CNAME" != "" ]; then
# openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=FR/ST=c2is/L=Lyon/O=c2is/CN=$CERTIFICAT_CNAME" -keyout /etc/apache2/ssl/ssl.key -out /etc/apache2/ssl/ssl.crt
#fi

exec "$@"
