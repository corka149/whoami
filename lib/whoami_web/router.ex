defmodule WhoamiWeb.Router do
  use WhoamiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WhoamiWeb do
    pipe_through :api

    get "/stats", InfoController, :stats
    get "/selfdestroy", InfoController, :selfdestroy
  end
end
