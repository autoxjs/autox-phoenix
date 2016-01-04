defmodule Dummy.Repo.Migrations.AlterShop do
  use Ecto.Migration

  def change do
    alter table(:shops) do
      add :owner_id, references(:owners, on_delete: :nothing)

      
    end
    create index(:shops, [:owner_id])

  end
end