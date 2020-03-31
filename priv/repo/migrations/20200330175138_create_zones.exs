defmodule EventManager.Repo.Migrations.CreateZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :external_id, :string
      add :capacity, :string
      add :name, :string
      add :numbered, :boolean, default: false, null: false
      add :max_price, :float
      add :event_id, references(:events, on_delete: :nothing)
      timestamps()
    end

  end
end
