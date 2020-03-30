defmodule EventManagerWeb.ZoneView do
  use EventManagerWeb, :view
  alias EventManagerWeb.ZoneView

  def render("index.json", %{zones: zones}) do
    %{data: render_many(zones, ZoneView, "zone.json")}
  end

  def render("show.json", %{zone: zone}) do
    %{data: render_one(zone, ZoneView, "zone.json")}
  end

  def render("zone.json", %{zone: zone}) do
    %{id: zone.id,
      external_id: zone.external_id,
      capacity: zone.capacity,
      name: zone.name,
      numbered: zone.numbered,
      max_price: zone.max_price}
  end
end
