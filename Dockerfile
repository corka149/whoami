FROM alpine
LABEL maintainer="corka149 <corka149@mailbox.org>"

ARG WHOAMI_VERSION

ADD ./_build/prod/rel/whoami /app

ENTRYPOINT ["/app/bin/whoami"]
CMD ["start"]
