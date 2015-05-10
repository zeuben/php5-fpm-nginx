#!/bin/bash

procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 1/worker_processes $procs/" /etc/nginx/nginx.conf

# Start supervisord and services
/usr/local/bin/supervisord -n
