defmodule Dummy.Batch do
  use Dummy.Web, :model

  schema "batches" do
    field :material, :string
    field :weight, :integer

    belongs_to :import_appointment, Dummy.Appointment
    belongs_to :export_appointment, Dummy.Appointment

    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(material weight import_appointment_id export_appointment_id)

  def create_changeset(model, params\\%{}) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\%{}) do 
    create_changeset(model, params)
  end

  def delete_changeset(model, _) do
    model
  end
end