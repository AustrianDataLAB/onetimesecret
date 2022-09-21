# Dockerfile for One-Time Secret
# http://onetimesecret.com

FROM ruby:2.6

RUN groupadd -g 1000 onetime && \
    useradd -m -d /var/lib/onetime -s /bin/nologin -u 1000 -g 1000 onetime
  
# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install -y \
    build-essential \
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
RUN chmod +x /usr/bin/entrypoint.sh

USER onetime

EXPOSE 7143
ENTRYPOINT /usr/bin/entrypoint.sh
