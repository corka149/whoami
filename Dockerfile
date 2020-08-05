# BUILD
FROM elixir:1.10 AS build

COPY . .

RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod
RUN mix deps.get && \
	mix release

RUN mkdir /whoami && \
    cp -r _build/prod/rel/whoami /whoami


# RUNTIME
FROM elixir:1.10-slim

LABEL maintainer="corka149 <corka149@mailbox.org>"

COPY --from=build /whoami .

# Security
RUN groupadd -r whoami && useradd -r -s /bin/false -g whoami whoami
RUN chown -R whoami:whoami /whoami

# Run
USER whoami
EXPOSE 4000
ENTRYPOINT ["/whoami/bin/whoami"]
CMD ["start"]
