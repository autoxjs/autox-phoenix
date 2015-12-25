defmodule Autox.Salsa do
  use Autox.Web, :model

  schema "salsas" do
    field :name, :string
    field :price, :decimal
    field :whatever, :string, virtual: true
    has_many :salsas_shops_relationship, Autox.TacosShopsRelationship
    has_many :shops, through: [:salsas_shops_relationship, :shop]
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w()

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end