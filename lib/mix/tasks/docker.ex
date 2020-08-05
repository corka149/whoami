
defmodule Mix.Tasks.Docker do
  @moduledoc """
  Creates an docker image with whoami.
  """
  use Mix.Task

  @shortdoc "Creates a docker image with tags"
  def run(_opts) do
    version = Mix.Project.config() |> Keyword.fetch!(:version)

    System.cmd("docker", ["build", "-t", "whoami:" <> version, "-t", "whoami:latest", "."],
      into: IO.stream(:stdio, :line)
    )
  end
end
