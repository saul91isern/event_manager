defmodule EventManager.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :external_id, :string
      add :event_date, :utc_datetime_usec
      add :sell_from, :utc_datetime_usec
      add :sell_to, :utc_datetime_usec
      add :sold_out, :boolean, default: false, null: false
      add :base_id, references(:bases, on_delete: :nothing)

      timestamps()
    end

  end
end
