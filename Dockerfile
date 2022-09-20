# Dockerfile for One-Time Secret
# http://onetimesecret.com

FROM ruby:2.6

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y \
    build-essential \
    redis-server \
  && rm -rf /var/lib/apt/lists/*

# Download and install OTS version 0.10.x
RUN set -ex && \
  mkdir -p /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime && \
  wget https://github.com/onetimesecret/onetimesecret/archive/main.tar.gz/ -O /tmp/ots.tar.gz && \
  tar xzf /tmp/ots.tar.gz -C /var/lib/onetime --strip-components=1 && \
  rm /tmp/ots.tar.gz && \
  cd /var/lib/onetime && \
  bundle install --frozen --deployment --without=dev && \
  cp -R etc/* /etc/onetime/

ADD entrypoint.sh /usr/bin/

# Add default config
ADD config.example /etc/onetime/config

VOLUME /etc/onetime /var/run/redis

EXPOSE 7143/tcp
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT /usr/bin/entrypoint.sh
