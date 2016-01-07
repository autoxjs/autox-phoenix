defmodule Dummy.Shop do
  use Dummy.Web, :model

  schema "shops" do
    field :name, :string
    field :location, :string

    belongs_to :owner, Dummy.Owner

    has_one :kitchen, Dummy.Kitchen
    has_many :chairs, Dummy.Chair

    has_many :tacos_shops_relationship, Dummy.TacosShopsRelationship
    has_many :tacos, through: [:tacos_shops_relationship, :taco]

    has_many :salsas_shops_relationship, Dummy.SalsasShopsRelationship
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