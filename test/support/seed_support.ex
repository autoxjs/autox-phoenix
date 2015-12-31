defmodule Autox.SeedSupport do
  alias Autox.Repo
  alias Autox.Shop
  alias Autox.Salsa
  alias Autox.Owner
  alias Autox.Chair
  alias Autox.Kitchen
  alias Autox.RelationUtils, as: Ru
  import Ecto
  def owner_attributes do
    %{ "name" => "Jackson Davis Test Shop" }
  end

  def shop_attributes do
    %{"name" => "test shop","location" => "testland"}
  end

  def chair_attributes do
    %{"size" => "extra-large"}
  end

  def salsa_attributes do
    %{"name" => "Special Verde",
      "price" => 22.4,
      "secret_sauce" => "horse semen"}
  end

  def build_chair do
    %Chair{}
    |> Chair.create_changeset(chair_attributes)
    |> Repo.insert!
  end

  def build_chair(shop) do
    shop
    |> build_assoc(:chairs)
    |> Chair.create_changeset(chair_attributes)
    |> Repo.insert!
  end

  def build_kitchen do
    %Kitchen{}
    |> Kitchen.create_changeset(%{})
    |> Repo.insert!
  end

  def build_kitchen(shop) do
    shop
    |> build_assoc(:kitchen)
    |> Kitchen.create_changeset(%{})
    |> Repo.insert!
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

  def build_shop(owner) do
    owner
    |> build_assoc(:shops)
    |> Shop.create_changeset(shop_attributes)
    |> Repo.insert!
  end

  def build_salsa do
    %Salsa{}
    |> Salsa.create_changeset(salsa_attributes)
    |> Repo.insert!
  end

  def salsa_to_shop(salsa, shop) do
    params = %{"id" => salsa.id, "type" => "salsas", "attributes" => %{"authorization_key" => "rover doge"}}
    {:insert, changeset} = Ru.caac(Repo, shop, :salsas, params)
    changeset 
    |> Repo.insert! 
    |> Repo.preload([:salsa, :shop])
  end
end