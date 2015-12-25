defmodule Autox.Repo.Migrations.AlterTacosShopsRelationship do
  use Ecto.Migration

  def change do
    alter table(:tacos_shops) do
      add :taco_id, references(:tacos, on_delete: :nothing)
      add :shop_id, references(:shops, on_delete: :nothing)

      
    end
    create index(:tacos_shops, [:taco_id])
    create index(:tacos_shops, [:shop_id])

  end
end