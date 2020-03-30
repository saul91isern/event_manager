defmodule EventManager.Repo.Migrations.CreateBases do
  use Ecto.Migration

  def change do
    create table(:bases) do
      add :external_id, :string
      add :sell_mode, :string
      add :title, :string

      timestamps()
    end

    create(unique_index(:bases, [:external_id], name: :unique_base))
  end
end
