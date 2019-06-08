defmodule WhoamiWeb.InfoController do

  alias Whoami.Helper

  use WhoamiWeb, :controller

  def stats(conn, _params) do
    stats = Helper.get_stats()
    json(conn, stats)
  end

  def selfdestroy(conn, _params) do
    Helper.create_bloating_process()
    conn
  end
end
