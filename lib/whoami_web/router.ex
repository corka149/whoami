defmodule WhoamiWeb.Router do
  use WhoamiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", WhoamiWeb do
    pipe_through :api

    get "/stats", InfoController, :stats
    get "/selfdestroy", InfoController, :selfdestroy
    get "/ready", InfoController, :ready
    get "/health", InfoController, :health
    get "/health/:value", InfoController, :change_health
  end
end
