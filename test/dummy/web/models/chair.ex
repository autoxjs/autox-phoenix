defmodule Dummy.Chair do
  use Dummy.Web, :model

  schema "chairs" do
    field :size, :string
    belongs_to :shop, Dummy.Shop
    timestamps
  end

  @create_fields ~w()
  @update_fields @create_fields
  @optional_fields ~w(shop_id size)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @create_fields, @optional_fields)
  end

  def update_changeset(model, params\\:empty) do 
    create_changeset(model, params)
  end
end