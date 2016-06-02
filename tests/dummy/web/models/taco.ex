defmodule Dummy.Taco do
  use Dummy.Web, :model

  schema "tacos" do
    field :name, :string
    field :calories, :integer

    has_many :tacos_shops_relationship, Dummy.TacosShopsRelationship
    has_many :shops, through: [:tacos_shops_relationship, :shop]
    timestamps
  end

  @create_fields ~w(name calories)
  @update_fields @create_fields
  @optional_fields ~w()

  def create_changeset(model, params\\%{}) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\%{}) do 
    create_changeset(model, params)
  end
end