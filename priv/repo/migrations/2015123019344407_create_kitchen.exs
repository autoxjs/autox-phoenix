defmodule Autox.Repo.Migrations.CreateKitchen do
  use Ecto.Migration

  def change do
    create table(:kitchens) do

      timestamps
    end

  end
end