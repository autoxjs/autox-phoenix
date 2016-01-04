defmodule Dummy.Repo.Migrations.AlterChair do
  use Ecto.Migration

  def change do
    alter table(:chairs) do
      add :shop_id, references(:shops, on_delete: :nothing)

      
    end
    create index(:chairs, [:shop_id])

  end
end