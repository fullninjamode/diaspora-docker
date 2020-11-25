FROM ruby:2.6

LABEL maintainer="ninjamo.de"
LABEL source="https://github.com/fullninjamode/diaspora-docker"

ARG DIASPORA_VER=0.7.14.0

ENV RAILS_ENV=production \
    UID=666 \
    GID=666

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
    build-essential \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libxslt-dev \
    imagemagick \
    ghostscript \
    curl \
    libmagickwand-dev \
    git \
    libpq-dev \
    nodejs \
    wget \
    cmake \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --GID ${GID} diaspora \
    && adduser --uid ${UID} --gid ${GID} \
    --home /diaspora --shell /bin/sh \
    --disabled-password --gecos "" diaspora

USER diaspora

WORKDIR /diaspora

RUN wget -qO- https://github.com/diaspora/diaspora/archive/v$DIASPORA_VER.tar.gz | tar xz --strip 1 \
    && mkdir /diaspora/log

COPY ./database.yml /diaspora/config/database.yml
COPY ./diaspora.yml /diaspora/config/diaspora.yml

RUN gem install bundler
RUN script/configure_bundler && bin/bundle install --full-index
