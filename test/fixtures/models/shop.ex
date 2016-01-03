defmodule Autox.Shop do
  use Autox.Web, :model

  schema "shops" do
    field :name, :string
    field :location, :string

    belongs_to :owner, Autox.Owner

    has_one :kitchen, Autox.Kitchen
    has_many :chairs, Autox.Chair

    has_many :tacos_shops_relationship, Autox.TacosShopsRelationship
    has_many :tacos, through: [:tacos_shops_relationship, :taco]

    has_many :salsas_shops_relationship, Autox.SalsasShopsRelationship
    has_many :salsas, through: [:salsas_shops_relationship, :salsa]
    timestamps
  end

  @create_fields ~w(name location)
  @update_fields @create_fields
  @optional_fields ~w(owner_id)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end