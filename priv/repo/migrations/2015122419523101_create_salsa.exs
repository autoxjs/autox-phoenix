defmodule Autox.Repo.Migrations.CreateSalsa do
  use Ecto.Migration

  def change do
    create table(:salsas) do
      add :name, :string
      add :price, :decimal

      timestamps
    end

  end
end