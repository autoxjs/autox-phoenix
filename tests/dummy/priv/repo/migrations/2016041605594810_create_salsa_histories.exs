defmodule Dummy.Repo.Migrations.CreateSalsaHistories do
  use Ecto.Migration

  def change do
    create table(:salsa_histories) do
      add :recordable_id, :integer
      add :permalink, :string
      add :type, :string
      add :name, :string
      add :message, :string
      add :scheduled_at, :datetime
      add :happened_at, :datetime
      add :mentioned_type, :string
      add :mentioned_id, :integer

      timestamps
    end

  end
end