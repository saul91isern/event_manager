defmodule EventManager.Events.EventLoader do
  @moduledoc """
    Manage events loader.
  """

  use GenServer

  alias EventManager.Events
  alias XmlToMap

  require Logger

  @url "https://gist.githubusercontent.com/miguelgf/2885fe812638bfb33f785a977f8b7e3c/raw/0bef14cee7d8beb07ec9dabd6b009499f65b85f0/response.xml"
  @seconds_in_day 60 * 60 * 24

  ## Client API
  def start_link(config \\ []) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  ## GenServer Callbacks

  @impl GenServer
  def init(state) do
    unless Application.get_env(:event_manager, :env) == :test do
      Process.send_after(self(), :load, 200)
    end

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:load, state) do
    reply = request()

    unless elem(reply, 0) == :ko do
      {:ok, resp} = 
        reply
        |> elem(1)
        |> XmlToMap.naive_map()
        |> do_load()
      
        Logger.info("Loaded #{Enum.count(resp)} base events")
    end
    Process.send_after(self(), :load, @seconds_in_day)
    {:noreply, state}
  end

  defp request do
    case HTTPoison.get!(@url) do
      %HTTPoison.Response{status_code: 200, body: body} -> 
        {:ok, body}
      error -> 
        Logger.debug("Error requesting data with status code: #{error.status_code}")
        {:ko, error}
    end 
  end

  defp do_load(%{"eventList" => eventList}) do
    eventList
    |> Map.get("#content")
    |> Map.get("output")
    |> Map.get("base_event")
    |> Events.load()
  end

  defp do_load(_), do: {:ok, []}
end
