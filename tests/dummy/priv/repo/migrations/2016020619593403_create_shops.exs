defmodule Dummy.Repo.Migrations.CreateShops do
  use Ecto.Migration

  def change do
    create table(:shops) do
      add :name, :string
      add :location, :string
      add :theme, :string
      add :inspected_at, :datetime

      timestamps
    end

  end
end