defmodule Dummy.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :name, :string
      add :material, :string

      timestamps
    end

  end
end