FROM elixir:1.9.4-alpine AS build

COPY . .

RUN \
    mkdir -p /opt/app && \
    chmod -R 777 /opt/app && \
    apk update && \
    apk --no-cache --update add \
      make \
      gcc \
      libc-dev \
      git \
      g++ \
      wget \
      curl \
      inotify-tools && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod
RUN mix deps.get && \
	mix release && \
  mix phx.digest

RUN mkdir /whoami && \
    cp -r _build/prod/rel/whoami /whoami

FROM alpine

RUN apk --no-cache --update add openssl \
        ncurses-libs \
        libc-dev

LABEL maintainer="corka149 <corka149@mailbox.org>"

COPY --from=build /whoami .

EXPOSE 4000

ENTRYPOINT ["/whoami/bin/whoami"]
CMD ["start"]