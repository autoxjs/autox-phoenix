defmodule Dummy.Repo.Migrations.AlterSalsasShopsRelationship do
  use Ecto.Migration

  def change do
    alter table(:salsas_shops) do
      add :salsa_id, references(:salsas, on_delete: :nothing)
      add :shop_id, references(:shops, on_delete: :nothing)

      
    end
    create index(:salsas_shops, [:salsa_id])
    create index(:salsas_shops, [:shop_id])

  end
end