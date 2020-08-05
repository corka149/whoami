defmodule Whoami.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Whoami.Supervisor]

    children = [
      Whoami.HealthManager,
      cowboy_plug()
    ]

    Supervisor.start_link(children, opts)
  end

  defp cowboy_plug() do
    {Plug.Cowboy,
     scheme: :http,
     plug: Whoami.WebServer,
     options: [port: 4000]}
  end
end
