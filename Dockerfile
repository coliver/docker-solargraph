ARG RUBY_VERSION=2.7.2
# Valid ruby versions here: https://hub.docker.com/_/ruby
FROM ruby:$RUBY_VERSION-alpine

# Latest Solargraph: https://github.com/castwide/solargraph/blob/master/lib/solargraph/version.rb
ARG SOLARGRAPH_VERSION=0.39.15

RUN apk --update add --no-cache --virtual .builddeps \
  gcc \
  make \
  musl-dev \
  && gem install --no-document solargraph --version $SOLARGRAPH_VERSION \
  && gem install bundler \
  && gem install yard \
  && apk del .builddeps

ENTRYPOINT bin/bash

RUN install -m 600 -d /data

WORKDIR /app

RUN yard gems

RUN solargraph download-core

ENTRYPOINT ["/usr/local/bundle/bin/solargraph", "socket", "-p", "7658", "-h", "0.0.0.0"]
