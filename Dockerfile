FROM elixir
LABEL maintainer="corka149 <corka149@mailbox.org>"

ARG WHOAMI_VERSION

ADD ./_build/prod/rel/whoami/releases/$WHOAMI_VERSION/whoami.tar.gz /app

ENTRYPOINT ["app/bin/whoami"]
CMD ["foreground"]
