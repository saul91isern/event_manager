defmodule EventManagerWeb.BaseView do
  use EventManagerWeb, :view
  alias EventManagerWeb.BaseView

  def render("index.json", %{bases: bases}) do
    %{data: render_many(bases, BaseView, "base.json")}
  end

  def render("show.json", %{base: base}) do
    %{data: render_one(base, BaseView, "base.json")}
  end

  def render("base.json", %{base: base}) do
    %{id: base.id,
      external_id: base.external_id,
      sell_mode: base.sell_mode,
      title: base.title}
  end
end
