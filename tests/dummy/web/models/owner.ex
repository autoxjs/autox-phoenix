defmodule Dummy.Owner do
  use Dummy.Web, :model

  schema "owners" do
    field :name, :string
    has_many :shops, Dummy.Shop
    timestamps
  end

  @create_fields ~w(name)
  @update_fields @create_fields
  @optional_fields ~w()

  def create_changeset(model, params\\%{}) do
    model
    |> cast(params, @create_fields, @optional_fields)
    |> cast_assoc(:shops)
  end

  def update_changeset(model, params\\%{}) do 
    create_changeset(model, params)
  end
end