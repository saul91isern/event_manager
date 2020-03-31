defmodule EventManagerWeb.EventController do
  use EventManagerWeb, :controller

  alias EventManager.Events

  action_fallback EventManagerWeb.FallbackController

  def index(conn, params) do
    events = Events.list_events(params)
    render(conn, "index.json", events: events)
  end
end
