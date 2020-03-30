defmodule EventManager.Events.Base do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventManager.Events.Event

  schema "bases" do
    field :external_id, :string
    field :sell_mode, :string
    field :title, :string
    
    has_many :events, Event
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(base, attrs) do
    base
    |> cast(attrs, [:external_id, :sell_mode, :title])
    |> validate_required([:external_id, :sell_mode, :title])
  end
end
