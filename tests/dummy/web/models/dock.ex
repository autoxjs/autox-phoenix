defmodule Dummy.Dock do
  use Dummy.Web, :model

  schema "docks" do
    field :name, :string
    field :status, :string

    has_many :trucks, Dummy.Truck
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(name status)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end

  def delete_changeset(model, _) do
    model
  end
end