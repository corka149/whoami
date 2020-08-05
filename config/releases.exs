import Config

config :whoami, :env_msg, System.fetch_env!("ENVIRONMENT_MESSAGE")
