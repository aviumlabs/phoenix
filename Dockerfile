# syntax=docker/dockerfile:1
FROM elixir:1.17-alpine

ARG PHX_VERSION=''
ARG APP_ROOT=/opt

ENV DATABASE_URL=''
ENV MIX_ENV=''
ENV PORT=4000

ENV WORKDIR=$APP_ROOT

RUN apk add --no-cache \
    openssl \
    make \
    gcc \
    musl-dev \
    postgresql16-client \ 
    inotify-tools \
    git \
    nodejs \
    npm \
    && npm install npm@latest -g \
    && mix local.hex --force \
    && mix archive.install hex phx_new $PHX_VERSION --force \
    && mix local.rebar --force

EXPOSE 4000-4025

CMD ["mix", "phx.server"]
