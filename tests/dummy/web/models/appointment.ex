defmodule Dummy.Appointment do
  use Dummy.Web, :model

  schema "appointments" do
    field :name, :string
    field :material, :string
    
    has_many :import_batches, Dummy.Batch, foreign_key: :import_appointment_id
    has_many :export_batches, Dummy.Batch, foreign_key: :export_appointment_id
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(name material)

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