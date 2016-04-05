defmodule Dummy.Repo.Migrations.AlterTrucks do
  use Ecto.Migration

  def change do
    alter table(:trucks) do
      add :dock_id, references(:docks, on_delete: :nothing)

      
    end
    create index(:trucks, [:dock_id])

  end
end