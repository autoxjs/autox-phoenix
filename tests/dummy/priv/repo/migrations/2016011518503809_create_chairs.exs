defmodule Dummy.Repo.Migrations.CreateChairs do
  use Ecto.Migration

  def change do
    create table(:chairs) do
      add :size, :string

      timestamps
    end

  end
end