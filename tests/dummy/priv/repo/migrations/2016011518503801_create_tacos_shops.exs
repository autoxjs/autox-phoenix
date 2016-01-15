defmodule Dummy.Repo.Migrations.CreateTacosShops do
  use Ecto.Migration

  def change do
    create table(:tacos_shops) do

      timestamps
    end

  end
end