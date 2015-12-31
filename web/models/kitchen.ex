defmodule Autox.Kitchen do
  use Autox.Web, :model

  schema "kitchens" do
    belongs_to :shop, Autox.Shop
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(shop_id)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end