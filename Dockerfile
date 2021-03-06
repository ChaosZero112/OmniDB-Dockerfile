  
# Use phusion/baseimage as base image.
FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Setup a software baseline, later updated at run time
RUN export DEBIAN_FRONTEND=noninteractive && \
  mkdir -p /etc/my_init.d && \
  apt-get -qq -y update && \
  apt-get dist-upgrade -y -qq -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" && \
  apt-get install -y -qq -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" software-properties-common && \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt-get -qq -y update && \
  apt-get install -qq -y --no-install-recommends -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" \
    autoconf \
    automake \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    dpkg-dev \
    file \
    g++ \
    gcc \
    git \
    gnupg \
    idle-python3.9 \
    imagemagick \
    libbz2-dev \
    libc6-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libevent-dev \
    libffi-dev \
    libgdbm-dev \
    libglib2.0-dev \
    libgmp-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    liblzma-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmaxminddb-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libpng-dev \
    libpq-dev \
    libreadline-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    libyaml-dev \
    make \
    mercurial \
    netbase \
    openssh-client \
    patch \
    procps \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    subversion \
    unzip \
    wget \
    xz-utils \
    zlib1g-dev && \
    apt-get -y -qq -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" autoremove && \
    rm -f /usr/bin/python /usr/bin/python3 /usr/bin/pydoc /usr/bin/idle /usr/bin/idle3 /usr/bin/pip /usr/bin/pip3 && \
    ln -s /usr/bin/idle-python3.9 /usr/bin/idle &&	\
    ln -s /usr/bin/idle-python3.9 /usr/bin/idle3 && \
    ln -s /usr/bin/pydoc3.9 /usr/bin/pydoc && \
    ln -s /usr/bin/python3.9 /usr/bin/python && \
    ln -s /usr/bin/python3.9 /usr/bin/python3 && \
    curl -q https://bootstrap.pypa.io/get-pip.py | python && \
    git clone -q https://github.com/OmniDB/OmniDB.git /opt/omnidb && \
    cd /opt/omnidb && \
    pip install setuptools wheel && \
    pip install -r requirements.txt && \
    unset DEBIAN_FRONTEND && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy runtime scripts and make executable
COPY scripts/* /etc/my_init.d/
RUN chmod +x /etc/my_init.d/*

# Setup ennvironment variables
ENV LISTENING_PORT="8000" \
LISTENING_ADDRESS="0.0.0.0" \
IS_SSL="" \
SSL_CERTIFICATE_FILE="" \
SSL_KEY_FILE="" \
SESSION_COOKIE_SECURE="" \
CSRF_COOKIE_SECURE=""

# Expose the (default) port
EXPOSE 8000

# Persistant storage
VOLUME ["/omnidb-server"]
