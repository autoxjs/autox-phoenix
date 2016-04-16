defmodule Dummy.Repo.Migrations.CreateBatches do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :material, :string
      add :weight, :integer

      timestamps
    end

  end
end