import Config

config :whoami,
  env_msg: System.fetch_env!("ENVIRONMENT_MESSAGE"),
  other_service_host: System.fetch_env!("OTHER_SERVICE_HOST")
