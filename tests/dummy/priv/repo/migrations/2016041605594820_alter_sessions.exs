defmodule Dummy.Repo.Migrations.AlterSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :owner_id, references(:owners, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      
    end
    create index(:sessions, [:owner_id])
    create index(:sessions, [:user_id])

  end
end