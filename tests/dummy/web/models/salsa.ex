defmodule Dummy.Salsa do
  use Dummy.Web, :model

  schema "salsas" do
    field :name, :string
    field :price, :decimal
    field :secret_sauce, :string
    field :whatever, :string, virtual: true
    has_many :salsas_shops_relationship, Dummy.SalsasShopsRelationship
    has_many :shops, through: [:salsas_shops_relationship, :shop]
    has_many :histories, {"salsa_histories", Dummy.History}, foreign_key: :recordable_id
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(name price secret_sauce)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end