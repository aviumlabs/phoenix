# syntax=docker/dockerfile:1
FROM elixir:1.14.5-alpine

ARG PHX_VERSION=''
ARG APP_ROOT=/opt
WORKDIR $APP_ROOT

RUN apk add --no-cache \
    make \
    gcc \
    musl-dev \
    postgresql15-client \ 
    inotify-tools \
    git \
    nodejs \
    curl \
    && curl -L https://npmjs.com/install.sh | sh \
    && mix local.hex --force \
    && mix archive.install hex phx_new $PHX_VERSION --force \
    && mix local.rebar --force

EXPOSE 4000

CMD ["mix", "phx.server"]
