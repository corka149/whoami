defmodule Whoami.HealthManager do
  use Agent

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  @doc """
  Starts the HealthManager with 100% health.
  """
  def start_link() do
    Agent.start_link(fn -> 100 end, name: __MODULE__)
  end

  @doc """
  Returns the health as %.
  """
  def current_health do
    Agent.get(__MODULE__, &(&1))
  end

  @doc """
  Can only be between 1 to 100.
  """
  def change_health(health) do
    Agent.update(__MODULE__, fn _ -> health end)
  end

  def is_healthy? do
    round(100 * :rand.uniform()) <= current_health()
  end
end
