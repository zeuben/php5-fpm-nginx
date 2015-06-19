#vim:set ft=dockerfile:
FROM ubuntu
MAINTAINER Yoanis Gil <gil.yoanis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# PHP5 Stack and nginx
RUN apt-get update && \ 
    apt-get -y install php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt php5-curl php5-cli php5-gd php5-pgsql\
                       php5-sqlite php5-common php-pear curl php5-json php5-redis php5-memcache nginx-full python-pip && \ 
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Supervisor config
RUN pip install supervisor supervisor-stdout

# Override nginx's default config
ADD ./default /etc/nginx/sites-available/default
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./supervisord.conf /etc/supervisord.conf

# Stop nginx and php-fpm
RUN service nginx stop
RUN service php5-fpm stop

# Volumes
VOLUME "/srv/www"
VOLUME "/var/log/nginx"

# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Expose Ports
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/bin/bash", "/start.sh"]
