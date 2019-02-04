FROM debian:stretch

MAINTAINER André Cianfarani <a.cianfarani@c2is.fr>

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get install -y apache2 && \
    mkdir /etc/apache2/ssl && \
    a2enmod rewrite ssl headers proxy proxy_fcgi && \
    chmod 777 /entrypoint.sh  && \
    a2dissite 000-default && \
    ln -s /etc/apache2/sites-available/vhost-website.conf /etc/apache2/sites-enabled/vhost-website.conf

ADD ports.conf /etc/apache2/ports.conf
ADD ssl.key /etc/apache2/ssl/ssl.key
ADD ssl.crt /etc/apache2/ssl/ssl.crt

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80
EXPOSE 443
