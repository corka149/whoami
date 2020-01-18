import Config

config :whoami, WhoamiWeb.Endpoint, server: true
config :whoami, :env_msg, System.fetch_env!("ENVIRONMENT_MESSAGE")
