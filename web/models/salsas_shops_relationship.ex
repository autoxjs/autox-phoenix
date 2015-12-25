defmodule Autox.SalsasShopsRelationship do
  use Autox.Web, :model

  schema "salsas_shops" do
    belongs_to :salsa, Autox.Salsa
    belongs_to :shop, Autox.Shop
    timestamps
  end

  @create_fields ~w(salsa_id shop_id)
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