defmodule Dummy.Repo.Migrations.CreateKitchens do
  use Ecto.Migration

  def change do
    create table(:kitchens) do

      timestamps
    end

  end
end