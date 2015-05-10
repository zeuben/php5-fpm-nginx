# Introduction

This is Dockerfile to build a container for php5, nginx and php-fpm alone with
some commonly used php5 exentsions. Many thanks to [ngineered](https://github.com/ngineered/nginx-php-fpm)
for their work on [nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm)


# Usage

* Pull the image from the docker hub:

```
docker pull yoanisgil/php5-fpm-nginx:latest
``` 

* Launch your application within the container provided by the pulled image:

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

- Start by installing on a directory of your choice:

```
* mkdir silex-app
* composer require silex/silex:~1.2
```

- With the editor of your choice the infamous hello world route to your index.php file

```
* vim index.php
* <?php
require_once __DIR__.'/../vendor/autoload.php'; 

$app = new Silex\Application(); 

$app->get('/hello/{name}', function($name) use($app) { 
        return 'Hello '.$app->escape($name); 
}); 

$app->run();
* Save and wait for the awesome to come ;)
```

- Launch the container :

```
docker run -p 8000:80 --name silex -v $(pwd):/srv/www -v /tmp:/var/log/nginx yoanisgil/php5-fpm-nginx
```

- You can now visit http://localhost:8000/hello/world

If you are running docker on OSX then you need to run *boot2docker ip* to figure out which URL to enter in your browser.
Also since dockers on OSX are actually run within a VirtualBox VM you need to be aware of how volumes work, see 
[more here](https://docs.docker.com/userguide/dockervolumes/)

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
