# syntax=docker/dockerfile:1
FROM elixir:1.17-alpine

ARG PHX_VERSION=''
ARG APP_ROOT=/opt/phoenix

ENV DATABASE_URL=''
ENV MIX_ENV=''
ENV PORT=4000
ENV WORKDIR=$APP_ROOT

RUN set -eux; \
	addgroup -g 935 -S phoenix; \
	adduser -u 935 -S -D -G phoenix -H -h /opt/phoenix -s /bin/ash phoenix; \
	install --verbose --directory --owner phoenix --group phoenix --mode 1755 /opt/phoenix

RUN apk add --no-cache \
    openssl \
    make \
    gcc \
    musl-dev \
    postgresql16-client \ 
    inotify-tools \
    git
    #nodejs \
    #npm \
    #&& npm install npm@latest -g \

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

USER phoenix

RUN mix local.hex --force \
    && mix archive.install hex phx_new $PHX_VERSION --force \
    && mix local.rebar --force

EXPOSE 4000-4025

CMD ["mix", "phx.server"]
