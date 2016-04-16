defmodule Dummy.Repo.Migrations.CreateShopRelationships do
  use Ecto.Migration

  def change do
    create table(:shop_relationships) do

      timestamps
    end

  end
end