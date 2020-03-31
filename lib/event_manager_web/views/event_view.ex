defmodule EventManagerWeb.EventView do
  use EventManagerWeb, :view
  alias EventManagerWeb.BaseView
  alias EventManagerWeb.EventView
  alias EventManagerWeb.ZoneView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      external_id: event.external_id,
      event_date: event.event_date,
      sell_from: event.sell_from,
      sell_to: event.sell_to,
      sold_out: event.sold_out,
      base: render_one(event.base, BaseView, "base.json"),
      zones: render_many(event.zones, ZoneView, "zone.json")
    }
  end
end
