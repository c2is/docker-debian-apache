# C2is container for Debian stretch Apache 2.4

### Usage 

##### Edit your /etc/hosts file and add the line:
```
127.0.0.1 projectname.loc
```
Host value could be changed according your choice below  
Warning for macosx and windows users : ip value should be changed according your Docker's VM ip

##### With docker-compose (use image already built from docker's hub)
```
# In your docker-compose.yml file
c2isapachephp:
    image: c2is/debian-apache
    ports:
        - 80:80
    environment:
        # Default: website.dev.acti
        - WEBSITE_HOST=projectname.dev.acti
        # Default: no, DocumentRoot have not the trailing /web/
        - SYMFONY_VHOST_COMPLIANT="no"
        - CERTIFICAT_CNAME=projectname.dev.acti
```

##### With docker directly
```
git clone git@github.com:c2is/docker-debian-apache.git
cd docker-debian-apache
docker build -t . c2isDebAp
docker run -d -e WEBSITE_HOST=projectname.dev.acti -e SYMFONY_VHOST_COMPLIANT=yes c2isDebAp
```

##### Then crawl you application : http://website.docker/