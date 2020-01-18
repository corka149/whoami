defmodule Whoami.Helper do

  def create_bloating_process() do
    spawn(__MODULE__, :append_endless, [""])
  end

  def append_endless(str) do
    append_text = :random.uniform() |> Float.to_string()
    append_endless(str <> append_text)
  end

  def get_stats() do
    %{
      host: get_host(),
      ipv4_addresses: get_ipv4_adresses(),
      env_msg: Application.fetch_env!(:whoami, :env_msg)
    }
  end

  defp get_host do
    {:ok, name} = :inet.gethostname()
    name
    |> to_string()
  end

  defp get_ipv4_adresses() do
    {:ok, addresses} = :inet.getif()
    Enum.map(addresses, fn {if_addr, _, _} -> if_addr end)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&ipv4_to_string/1)
  end

  defp ipv4_to_string(ipv4), do: Enum.reduce ipv4, fn x, y -> "#{y}.#{x}" end
end
