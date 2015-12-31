defmodule Autox.Repo.Migrations.CreateTacosShopsRelationship do
  use Ecto.Migration

  def change do
    create table(:tacos_shops) do

      timestamps
    end

  end
end