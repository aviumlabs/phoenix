# syntax=docker/dockerfile:1
FROM elixir:1.15.4-alpine

ARG PHX_VERSION=''
ARG APP_ROOT=/opt
WORKDIR $APP_ROOT

RUN apk add --no-cache \
    openssl \
    make \
    gcc \
    musl-dev \
    postgresql15-client \ 
    inotify-tools \
    git \
    nodejs \
    npm \
    && npm install npm@latest -g \
    && mix local.hex --force \
    && mix archive.install hex phx_new $PHX_VERSION --force \
    && mix local.rebar --force

EXPOSE 4000

CMD ["mix", "phx.server"]
