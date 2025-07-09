FROM ruby:3.4.4

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
      curl \
      libpq-dev \
      libvips42 \
      postgresql-client \
      git \
      nodejs \
      npm

WORKDIR /rails
