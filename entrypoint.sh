#!/bin/bash

# # start Redis
# /etc/init.d/redis-server start

# start OTS
cd /var/lib/onetime && bundle exec thin -e dev -R config.ru -p 7143 start
