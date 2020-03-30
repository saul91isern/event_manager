defmodule EventManager.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventManager.Events.Base
  alias EventManager.Events.Zone

  schema "events" do
    field :event_date, :utc_datetime_usec
    field :external_id, :string
    field :sell_from, :utc_datetime_usec
    field :sell_to, :utc_datetime_usec
    field :sold_out, :boolean, default: false
    belongs_to :base, Base
    has_many :zones, Zone


    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:external_id, :event_date, :sell_from, :sell_to, :sold_out])
    |> validate_required([:external_id, :event_date, :sell_from, :sell_to, :sold_out])
  end
end
