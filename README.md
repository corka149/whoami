# Whoami

Simple web service for messing around with Kubernetes, Elixir/Erlang and cowboy.

## Getting start

  * Start `whoami` locally with `cargo run`

Endpoints:
```
GET  /v1/stats
GET  /v1/selfdestroy
GET  /v1/ready
GET  /v1/health
GET  /v1/health/:value
GET  /v1/askother
```


## Config of Whoami

Environment variables:
```
NAME                  DESCRIPTION
----                  -----------
ENVIRONMENT_MESSAGE   Will be return from server
OTHER_SERVICE_HOST    Address of other whomai server
```
