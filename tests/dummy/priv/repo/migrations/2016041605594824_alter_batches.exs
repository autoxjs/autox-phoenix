defmodule Dummy.Repo.Migrations.AlterBatches do
  use Ecto.Migration

  def change do
    alter table(:batches) do
      add :import_appointment_id, references(:appointments, on_delete: :nothing)
      add :export_appointment_id, references(:appointments, on_delete: :nothing)

      
    end
    create index(:batches, [:import_appointment_id])
    create index(:batches, [:export_appointment_id])

  end
end