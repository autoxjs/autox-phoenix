defmodule Autox.TacosShopsRelationship do
  use Autox.Web, :model

  schema "tacos_shops" do
    belongs_to :taco, Autox.Taco
    belongs_to :shop, Autox.Shop
    timestamps
  end

  @create_fields ~w(taco_id shop_id)
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