defmodule Dummy.Repo.Migrations.CreateSalsas do
  use Ecto.Migration

  def change do
    create table(:salsas) do
      add :name, :string
      add :price, :decimal
      add :secret_sauce, :string

      timestamps
    end

  end
end