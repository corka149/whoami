defmodule WhoamiWeb.InfoController do

  alias Whoami.Helper
  alias Whoami.HealthManager

  require Logger

  use WhoamiWeb, :controller

  def stats(conn, _params) do
    stats = Helper.get_stats()
    json(conn, stats)
  end

  def selfdestroy(conn, _params) do
    Helper.create_bloating_process()
    resp(conn, 200, "Started self-destruction")
  end

  def ready(conn, _params) do
    Logger.info "Readiness was checked."
    resp(conn, 200, "I am ready.")
  end

  def health(conn, _params) do
    if HealthManager.is_health?() do
      resp(conn, 200, "I am fine.")
    else
      Logger.warn("Whoami is not healthy.")
      resp(conn, 500, "I am sick.")
    end
  end

  def change_health(conn, %{"value" => health_value} = _) do
    health_value = String.to_integer(health_value)
    if health_value > 0 and health_value < 101 do

      resp(conn, 200, "Health changed to #{health_value}%.")
    else
      resp(conn, 400, "Health value must be greater then 0 or lower/equal then 100.")
    end
  end
end
