defmodule Whoami.WebServer do

  alias Whoami.Helper
  alias Whoami.HealthManager

  import Plug.Conn

  require Logger

  def init(options) do
    Logger.info("Init http interface. Listens on port 4000")

    options
  end

  # Stats
  def call(%{request_path: "/v1/stats"} = conn, _params) do
    stats = Helper.get_stats()
    send_resp(conn, 200, Jason.encode!(stats))
  end

  # Self-destruction
  def call(%{request_path: "/v1/selfdestroy"} = conn, _params) do
    Helper.create_bloating_process()
    send_resp(conn, 200, "Started self-destruction")
  end

  # Ready
  def call(%{request_path: "/v1/ready"} = conn, _params) do
    Logger.info "Readiness was checked."
    send_resp(conn, 200, "I am ready.")
  end

  # Health
  def call(%{request_path: "/v1/health"} = conn, _params) do
    if HealthManager.is_healthy?() do
      send_resp(conn, 200, "I am fine.")
    else
      Logger.warn("Whoami is not healthy.")
      send_resp(conn, 500, "I am sick.")
    end
  end

  # Change health
  def call(%{request_path: "/v1/health/" <> health_value} = conn, _params) do
    health_value = String.to_integer(health_value)
    if health_value > 0 and health_value < 101 do
      HealthManager.change_health(health_value)
      send_resp(conn, 200, "Health changed to #{health_value}%.")
    else
      send_resp(conn, 400, "Health value must be greater then 0 or lower/equal then 100.")
    end
  end

  # Fallbacks
  def call(conn, _params) do
    routes = ~s"""
      GET  /v1/stats
      GET  /v1/selfdestroy
      GET  /v1/ready
      GET  /v1/health
      GET  /v1/health/:value
    """

    send_resp(conn, 404, "NOT FOUND - Possible routes:\n" <> routes)
  end

end
