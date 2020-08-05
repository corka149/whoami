use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :whoami,
  env_msg: "Test fake environment variable message",
  other_service_host: "http://127.0.0.1:4000"
