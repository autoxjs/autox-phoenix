defmodule Dummy.Repo.Migrations.CreateShop do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :name, :string
      add :location, :string

      timestamps
    end

  end
end