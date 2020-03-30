defmodule EventManager.Events.Zone do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventManager.Events.Event

  schema "zones" do
    field :capacity, :string
    field :external_id, :string
    field :max_price, :float
    field :name, :string
    field :numbered, :boolean, default: false
    belongs_to :event, Event

    timestamps()
  end

  @doc false
  def changeset(zone, attrs) do
    zone
    |> cast(attrs, [:external_id, :capacity, :name, :numbered, :max_price])
    |> validate_required([:external_id, :capacity, :name, :numbered, :max_price])
  end
end
