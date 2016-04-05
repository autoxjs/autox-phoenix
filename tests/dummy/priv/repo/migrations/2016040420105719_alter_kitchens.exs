defmodule Dummy.Repo.Migrations.AlterKitchens do
  use Ecto.Migration

  def change do
    alter table(:kitchens) do
      add :shop_id, references(:shops, on_delete: :nothing)

      
    end
    create index(:kitchens, [:shop_id])

  end
end