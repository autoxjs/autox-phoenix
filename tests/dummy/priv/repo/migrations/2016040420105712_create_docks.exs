defmodule Dummy.Repo.Migrations.CreateDocks do
  use Ecto.Migration

  def change do
    create table(:docks) do
      add :name, :string
      add :status, :string

      timestamps
    end

  end
end