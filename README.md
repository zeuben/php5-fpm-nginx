# Introduction

This is Dockerfile to build a container for php5, nginx and php-fpm alone with
some commonly used php5 exentsions. Many thanks to [ngineered](https://github.com/ngineered/nginx-php-fpm)
for their work on [nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm)


# Usage

* Pull the image from the docker hub:

```
docker pull yoanisgil/php5-fpm-nginx:latest
``` 

* Launch your application within a container provided by the pulled image:

```
docker run -p 8000:80 --name appname -v /app/root:/srv/www -v /path/to/nginx/log:/var/log/nginx yoanisgil/php5-fpm-nginx 
```

This will expose port 8000 on the host already mapped to port 80 on the container. "/app/root" is your application root,
which is usally where your index.php lives. We did not assume any particular application structure, so as long as the URL
path is a valid one to your application pages should be properly served, as well as static resources (See the note on static
files)


# Nginx configuration

Upon launch the startup script will setup as many nginx workers as available in the host. For further details refer to
file nginx.conf within this report. 

# Note on static files.

Nginx has been configured such that static files won't bre processed by php-fpm, nor log records will be created:

```
location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
    access_log        off;
    log_not_found     off;
    expires           5d;
}
```

# Silex example 

Coming soon

# List of preinstalled php extension.

* mysql
* imap
* mcrypt
* curl
* gd
* pgsql
* sqlite
* json
* redis
* memcache
