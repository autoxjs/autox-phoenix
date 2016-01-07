defmodule Dummy.Repo.Migrations.CreateSalsasShopsRelationship do
  use Ecto.Migration

  def change do
    create table(:salsas_shops) do
      add :authorization_key, :string

      timestamps
    end

  end
end