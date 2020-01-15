FROM elixir
LABEL maintainer="corka149 <corka149@mailbox.org>"

ARG WHOAMI_VERSION

ADD ./_build/prod/rel/whoami /app
RUN apt install openssl

ENTRYPOINT ["/app/bin/whoami"]
CMD ["start"]
