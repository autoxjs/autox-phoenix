defmodule Autox.RelationUtilsTest do
  use Autox.ModelCase
  alias Autox.Repo
  alias Autox.Shop
  alias Autox.Owner
  alias Autox.Chair
  alias Autox.Kitchen
  alias Autox.RelationUtils, as: Ru
  alias Autox.SalsasShopsRelationship
  import Autox.SeedSupport
  setup do
    shop = build_shop
    {:ok, shop: shop}
  end

  test "caac - existing - through many-one", %{shop: shop} do
    salsa = build_salsa
    params = %{"id" => salsa.id, "type" => "salsas", "attributes" => %{"authorization_key" => "rover doge"}}
    assert {:insert, changeset} = Ru.caac(Repo, shop, :salsas, params)
    assert changeset.valid?
    case changeset |> Repo.insert do
      {:ok, salsa_relation} ->
        assert %SalsasShopsRelationship{salsa_id: salsa_id, shop_id: shop_id, authorization_key: "rover doge"} = 
          salsa_relation
        assert salsa.id == salsa_id
        assert shop.id == shop_id
        [s] = shop |> assoc(:salsas) |> Repo.all
        assert s.id == salsa.id
      {:error, cs} -> refute cs
    end
  end

  test "caac - new - through many-one", %{shop: shop} do
    params = %{"type" => "salsas", "attributes" => salsa_attributes}
    assert {:error, msg} = Ru.caac(Repo, shop, :salsas, params)
    assert msg =~ "many"
  end

  test "caac - existing - belongs_to", %{shop: shop} do
    owner = build_owner
    params = %{"id" => owner.id, "type" => "owners"}
    assert {:update, changeset} = Ru.caac(Repo, shop, :owner, params)
    assert changeset.valid?
    case changeset |> Repo.update do
      {:ok, shop} ->
        assert %Shop{id: id, owner_id: owner_id} = shop
        assert owner_id == owner.id
      {:error, cs} -> refute cs
    end
  end

  test "caac - new - belongs_to", %{shop: shop} do
    params = %{"type" => "owners", "attributes" => owner_attributes}
    assert {:error, msg} = Ru.caac(Repo, shop, :owner, params)
    assert msg =~ "belongs_to"
  end

  test "caac - existing - has_one", %{shop: shop} do
    kitchen = build_kitchen
    params = %{"id" => kitchen.id, "type" => "kitchens"}
    assert {:update, changeset} = Ru.caac(Repo, shop, :kitchen, params)
    assert changeset.valid?
    case changeset |> Repo.update do
      {:ok, k} ->
        assert %Kitchen{id: id, shop_id: shop_id} = k
        assert id == kitchen.id
        assert shop_id == shop.id
      {:error, cs} -> refute cs
    end
  end

  test "caac - new - has_one", %{shop: shop} do
    params = %{"type" => "kitchens"}
    assert {:insert, changeset} = Ru.caac(Repo, shop, :kitchen, params)
    assert changeset.valid?
    case changeset |> Repo.insert do
      {:ok, kitchen} ->
        assert %Kitchen{id: id, shop_id: shop_id} = kitchen
        assert id
        assert shop_id == shop.id
      {:error, cs} -> refute cs
    end
  end

  test "caac - existing - has_many", %{shop: shop} do
    chair = build_chair
    params = %{"id" => chair.id, "type" => "chairs"}
    assert {:update, changeset} = Ru.caac(Repo, shop, :chairs, params)
    assert changeset.valid?
    case changeset |> Repo.update do
      {:ok, c} ->
        assert %Chair{id: id, shop_id: shop_id} = c
        assert id == chair.id
        assert shop_id == shop.id
      {:error, cs} -> refute cs
    end
  end

  test "caac - new - has_many", %{shop: shop} do
    params = %{"type" => "chairs", "attributes" => chair_attributes}
    assert {:insert, changeset} = Ru.caac(Repo, shop, :chairs, params)
    assert changeset.valid?
    case changeset |> Repo.insert do
      {:ok, c} ->
        assert %Chair{id: id, shop_id: shop_id} = c
        assert id
        assert shop_id == shop.id
      {:error, cs} -> refute cs
    end
  end
end