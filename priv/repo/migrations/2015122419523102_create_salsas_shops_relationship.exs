defmodule Autox.Repo.Migrations.CreateSalsasShopsRelationship do
  use Ecto.Migration

  def change do
    create table(:salsas_shops) do

      timestamps
    end

  end
end