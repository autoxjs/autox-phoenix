defmodule Dummy.Repo.Migrations.CreateTacos do
  use Ecto.Migration

  def change do
    create table(:tacos) do
      add :name, :string
      add :calories, :integer

      timestamps
    end

  end
end