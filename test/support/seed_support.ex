defmodule Autox.SeedSupport do
  alias Autox.Owner
  alias Autox.Shop
  alias Autox.Repo
  def owner_attributes do
    %{ "name" => "Jackson Davis Test Shop" }
  end

  def shop_attributes do
    %{"name" => "test shop","location" => "testland"}
  end

  def build_owner do
    %Owner{}
    |> Owner.create_changeset(owner_attributes)
    |> Repo.insert!
  end

  def build_shop do
    %Shop{}
    |> Shop.create_changeset(shop_attributes)
    |> Repo.insert!
  end
end